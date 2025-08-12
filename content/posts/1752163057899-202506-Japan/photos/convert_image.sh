#!/bin/bash

# Smart JPEG optimizer - resizes oversized images and optimizes quality
# Handles large images by resizing them to reasonable web dimensions
# Requires: imagemagick

# Configuration
BASE_DIR="."
MAX_WIDTH=1920        # Maximum width in pixels
MAX_HEIGHT=1920       # Maximum height in pixels  
JPEG_QUALITY=85       # JPEG quality (1-100)
BACKUP_SUFFIX="_original"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}📸 Smart JPEG Optimizer${NC}"
echo -e "${BLUE}========================${NC}"
echo "Max dimensions: ${MAX_WIDTH}x${MAX_HEIGHT}px | Quality: ${JPEG_QUALITY}%"
echo ""

# Check required tools
check_dependency() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}❌ Error: $1 is not installed${NC}"
        echo "Please install ImageMagick and try again"
        exit 1
    fi
}

echo "Checking dependencies..."
check_dependency "convert"
check_dependency "identify"
echo -e "${GREEN}✓ ImageMagick found${NC}"
echo ""

# Navigate to base directory
if [ ! -d "$BASE_DIR" ]; then
    echo -e "${RED}❌ Error: Directory $BASE_DIR not found${NC}"
    echo "Current directory: $(pwd)"
    echo "Please run this script from the correct location or modify BASE_DIR"
    exit 1
fi

cd "$BASE_DIR" || exit 1
echo -e "${BLUE}Working in: $(pwd)${NC}"
echo ""

# Find all JPG files recursively
echo "Searching for JPEG files..."
jpg_files=$(find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) | sort)

if [ -z "$jpg_files" ]; then
    echo -e "${YELLOW}⚠️  No JPEG files found in $(pwd)${NC}"
    exit 1
fi

# Count total files
total_files=$(echo "$jpg_files" | wc -l | tr -d ' ')
echo -e "${GREEN}Found $total_files JPEG files${NC}"
echo ""

processed_files=0
resized_files=0
total_saved=0

# Function to get image dimensions
get_dimensions() {
    local file="$1"
    identify -format "%wx%h" "$file" 2>/dev/null
}

# Function to check if image is oversized
is_oversized() {
    local dimensions="$1"
    local width=$(echo "$dimensions" | cut -d'x' -f1)
    local height=$(echo "$dimensions" | cut -d'x' -f2)
    
    if [ "$width" -gt "$MAX_WIDTH" ] || [ "$height" -gt "$MAX_HEIGHT" ]; then
        return 0  # true - oversized
    else
        return 1  # false - normal size
    fi
}

# Process each JPEG file
while IFS= read -r jpg_file; do
    if [ -z "$jpg_file" ]; then continue; fi
    
    # Get filename and path info
    filename=$(basename "$jpg_file")
    dir_path=$(dirname "$jpg_file")
    name_no_ext="${filename%.*}"
    extension="${filename##*.}"
    
    # Skip if already processed (has backup)
    if [[ "$filename" == *"$BACKUP_SUFFIX"* ]]; then
        echo -e "${BLUE}⏭️  Skipping backup file: $jpg_file${NC}"
        continue
    fi
    
    # Skip if backup already exists (already processed)
    backup_file="${dir_path}/${name_no_ext}${BACKUP_SUFFIX}.${extension}"
    if [ -f "$backup_file" ]; then
        echo -e "${BLUE}⏭️  Already processed: $jpg_file${NC}"
        continue
    fi
    
    echo -e "${YELLOW}🔍 Analyzing: $jpg_file${NC}"
    
    # Get image dimensions and file size
    dimensions=$(get_dimensions "$jpg_file")
    original_size=$(stat -f%z "$jpg_file" 2>/dev/null || stat -c%s "$jpg_file" 2>/dev/null)
    
    if [ -z "$dimensions" ]; then
        echo -e "   ${RED}❌ Could not read image dimensions${NC}"
        echo ""
        continue
    fi
    
    echo -e "   📏 Dimensions: $dimensions"
    echo -e "   📦 Size: $(numfmt --to=iec $original_size 2>/dev/null || echo $original_size)"
    
    # Create backup of original
    cp "$jpg_file" "$backup_file"
    echo -e "   ${BLUE}💾 Backup created${NC}"
    
    # Determine processing strategy
    temp_file="${dir_path}/${name_no_ext}_temp.${extension}"
    
    if is_oversized "$dimensions"; then
        echo -e "   ${CYAN}📐 Image is oversized - will resize and optimize${NC}"
        
        # Resize large image while maintaining aspect ratio
        convert "$jpg_file" \
            -resize "${MAX_WIDTH}x${MAX_HEIGHT}>" \
            -quality $JPEG_QUALITY \
            -strip \
            -sampling-factor 4:2:0 \
            -colorspace sRGB \
            -interlace Plane \
            "$temp_file"
            
        resized_files=$((resized_files + 1))
    else
        echo -e "   ${GREEN}✅ Good size - will only optimize quality${NC}"
        
        # Only optimize quality for normal-sized images
        convert "$jpg_file" \
            -quality $JPEG_QUALITY \
            -strip \
            -sampling-factor 4:2:0 \
            -colorspace sRGB \
            -interlace Plane \
            "$temp_file"
    fi
    
    if [ $? -eq 0 ]; then
        # Replace original with processed version
        mv "$temp_file" "$jpg_file"
        
        # Get new dimensions and file size
        new_dimensions=$(get_dimensions "$jpg_file")
        optimized_size=$(stat -f%z "$jpg_file" 2>/dev/null || stat -c%s "$jpg_file" 2>/dev/null)
        
        # Calculate savings
        if [ "$original_size" -gt 0 ] && [ "$optimized_size" -gt 0 ]; then
            saved_bytes=$((original_size - optimized_size))
            total_saved=$((total_saved + saved_bytes))
            
            if [ $saved_bytes -gt 0 ]; then
                savings_percent=$(( (saved_bytes * 100) / original_size ))
                echo -e "   ${GREEN}✅ Processed successfully${NC}"
                if [ "$dimensions" != "$new_dimensions" ]; then
                    echo -e "   📏 New dimensions: $new_dimensions"
                fi
                echo -e "   📊 Size: $(numfmt --to=iec $original_size 2>/dev/null || echo $original_size) → $(numfmt --to=iec $optimized_size 2>/dev/null || echo $optimized_size) (${savings_percent}% smaller)"
            else
                echo -e "   ${YELLOW}ℹ️  File size unchanged${NC}"
            fi
        else
            echo -e "   ${GREEN}✅ Processing completed${NC}"
        fi
        
        processed_files=$((processed_files + 1))
    else
        echo -e "   ${RED}❌ Processing failed${NC}"
        # Restore original if processing failed
        mv "$backup_file" "$jpg_file"
        rm -f "$temp_file"
    fi
    
    echo ""
    
done <<< "$jpg_files"

echo -e "${BLUE}========================${NC}"
echo -e "${GREEN}🎉 Processing complete!${NC}"
echo ""
echo -e "${GREEN}📈 Summary:${NC}"
echo -e "   Files processed: ${processed_files}/${total_files}"
echo -e "   Files resized: ${resized_files}"
if [ $total_saved -gt 0 ]; then
    echo -e "   Total space saved: $(numfmt --to=iec $total_saved 2>/dev/null || echo $total_saved)"
fi
echo ""
echo -e "${YELLOW}📝 What was done:${NC}"
echo "• Images larger than ${MAX_WIDTH}x${MAX_HEIGHT}px were resized (maintaining aspect ratio)"
echo "• All images were optimized to ${JPEG_QUALITY}% quality"
echo "• Metadata was stripped to reduce file size"
echo "• Original files are backed up with '${BACKUP_SUFFIX}' suffix"
echo ""
echo -e "${BLUE}🗑️  To remove all backups later:${NC}"
echo "find . -name '*${BACKUP_SUFFIX}.*' -delete"
