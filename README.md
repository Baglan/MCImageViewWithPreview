# MCImageViewWithPreview

Goal for this project is to create a replacement for the UIImageView component, that would not block the main thread while rendering a high resolution image, meanwhile providing a temporary "preview" image instead.

## Installation

1. Copy files from the "Classes" folder to your project
2. include "MCImageViewWithPreview.h"

## Usage

    MCImageViewWithPreview * imageView = [[MCImageViewWithPreview alloc] initWithFrame:self.view.bounds];
    imageView.preview = [UIImage imageNamed:@"preview-image"];
    imageView.image = [UIImage imageNamed:@"high-resolution-image"];
    
## License

Files in this project are available under the MIT License