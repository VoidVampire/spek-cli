# spek-cli

spek-cli is a command-line tool to enhance the functionality of [Spek](https://www.spek.cc/), a free and open-source acoustic spectrum analyzer. This tool allows users to open multiple files within a directory at once and take screenshots of Spek's spectrogram output window for one or all files in the directory.

## Features

- Open all files within a directory.
- Take screenshots of Spek's spectrogram output window for one file or all files in the directory.
  - Screenshots can be saved as a PNG in the directory or copied to the clipboard.

## Requirements

- [Spek](https://www.spek.cc/)
- [NirCmd](https://www.nirsoft.net/utils/nircmd.html)
- [ImageMagick](https://imagemagick.org/)

## Setup

1. Clone this repository to your local machine.

2. Open the `.bat` file and set the following paths according to your installation:

    ```bat
    set "spekPath=C:\Program Files\Spek\spek.exe"
    set "nircmdPath=C:\nircmd-x64\nircmd.exe"
    set "magickPath=C:\Program Files\ImageMagick-7.1.1-Q16-HDRI\magick.exe"
    ```

3. Add the `.bat` file to your PATH in Windows.

## Usage

Run `spek-cli` from the command prompt with the following syntax:

```sh
spek-cli [options] filename_or_directory
```

### Options

- `-save`: Saves a screenshot in the directory of the file.
- `-clipboard`: Copies screenshot to the clipboard.
If a directory is specified with either options, then it will create a collage of all screenshots.

### Examples

- **Open all files in a directory:**

    ```sh
    spek-cli "C:\Users\Shree\Desktop\demo"
    ```

- **Take a screenshot and save it in the directory:**

    ```sh
    spek-cli -save "C:\Users\Shree\Desktop\demo\c_01.mp3"
    ```

- **Take a screenshot and copy it to the clipboard:**

    ```sh
    spek-cli -clipboard "C:\Users\Shree\Desktop\demo\c_01.mp3"
    ```

- **Process all files in a directory and save collage screenshot:**

    ```sh
    spek-cli -save "C:\Users\Shree\Desktop\demo"
    ```

- **Process all files in a directory and copied collage screenshot to the clipboard:**

    ```sh
    spek-cli -clipboard "C:\Users\Shree\Desktop\demo"
    ```
  

## Demo

[https://github.com/VoidVampire/spek-cli/assets/80760499/30f695ba-87ef-424e-80f2-87bee7540af6](https://github.com/VoidVampire/spek-cli/assets/80760499/30f695ba-87ef-424e-80f2-87bee7540af6)

## Todo

1. Create a single window while opening all files in a directory.
2. Higher precision in taking automated screenshots.
3. Fix the need of `timeout /t 2 /nobreak > nul` every few commands for directoty clipping.
   
## License

This project is licensed under the GPLv3 License - see the [LICENSE](LICENSE) file for details.

---

Feel free to adjust or expand upon this as needed.
