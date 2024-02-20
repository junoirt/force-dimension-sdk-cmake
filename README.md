# Force Dimension CMake

## Intro

The installation process for Force Dimension SDK has been abstracted into CMake to make the process standard.
It also provides automatic environment variable and systemd setup.

## Building and Installing

### Downloading/Upgrading the SDK

To install/upgrade the abstracted CMake install process of the SDK :

* Download and extract the [Linux (x86_64) archive of the sdk](https://www.forcedimension.com/software)
* Create a `OEM/sdk` folder at the root of this repo and extract the corresponding folders from the archive to `OEM/sdk/include` and `OEM/sdk/lib`
* If the SDK version is above the current one from this repo (3.17.0), bump the version in all the CMake files

### Building and installing the SDK

CMake options are available in the following table.

| CMake Option | Default | Description  |
| -------------| --------| -------------|
| [`CMAKE_INSTALL_PREFIX`](https://cmake.org/cmake/help/latest/variable/CMAKE_INSTALL_PREFIX.html) | `/usr/local`                  | Standard CMake variable that chooses to change the installation location directory. **Warning: if `CMAKE_INSTALL_PREFIX` directory doesn't exist, it will be created with the permissions/ownership of the user that executes the `cmake --install` command**  |

Configure, in release:

```console
cmake -B build
sudo cmake --install build
```

## Using in a CMakeLists.txt

```console
<some_code>
find_package(ForceDimension 3.17.0 REQUIRED)
<some_code>
target_link_libraries(<target_name> ForceDimension::dhd)
target_link_libraries(<target_name> ForceDimension::drd)
```

## Testing with a compatible device

A udev rule needs to be created in order to allow full access to the USB haptic devices:

```console
sudo nano /etc/udev/rules.d/80-usb-force-dimension.rules
```

and copy-paste the following rules:

```console
# Force Dimension haptic devices
SUBSYSTEM=="usb", ACTION=="add", ATTR{idVendor}=="1451", MODE:="0666"
SUBSYSTEM=="usb", ACTION=="add", ATTR{idVendor}=="04b4", ATTR{idProduct}=="8613", MODE:="0666"

# Novint haptic device
SUBSYSTEM=="usb", ACTION=="add", ATTR{idVendor}=="0403", ATTR{idProduct}=="cb48", MODE:="0666"
```
