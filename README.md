# MATLAB Conv2D From Scratch

This repository contains a **from-scratch Conv2D implementation in MATLAB** (no built-in `conv2` or deep learning libraries).  
It was developed as part of a Signals & Systems assignment, focusing on understanding how convolution, stride, padding, and filter stacks work at a low level.

---

## ✨ Features
- Custom **Conv2D function** (`conv2D.m`) with:
  - Multiple filters (3D filter tensors)
  - `stride` and `padding` (`'same'` or `'valid'`)
  - Multi-channel input support (RGB/grayscale)
- Zero-padding helper function
- Two convolution layers applied sequentially:
  - **Layer 1 filters (3×3, stride=1, padding='same')**:
    - Horizontal edge detector
    - Vertical edge detector
    - Sharpening
    - Weighted averaging (Gaussian-like)
  - **Layer 2 filters (2×2, stride=2, padding='valid')**:
    - Roberts X
    - Roberts Y
    - 2×2 averaging
- Visualization with **subplot figures**:
  - Original image + feature maps of layer 1
  - Feature maps of layer 2


