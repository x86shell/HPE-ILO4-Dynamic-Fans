# HPE ILO4 Dynamic Fans

Dynamic Fan Control for ILO4 modded with "Silence of the fans".

Place `fans.sh` and `fanpwd` in /

sshpass is required for this software to work correctly.

## Installation

1. **Configure ILO Details:**
   - Edit the `fans.sh` script and add your ILO details:
     ```sh
     nano fans.sh
     ```
   - Update the following variables with your ILO IP, username, and other necessary details.

2. **Add Password to `fanpwd` File:**
   - Create a file named `fanpwd` and add your ILO password:
     ```sh
     echo 'your_ilo_password' > fanpwd
     ```
3. **Install the Service/Timer:**
   - Copy the `dynamicfan.service` and `dynamicfan.timer` files to the systemd directory:
     ```sh
     sudo cp dynamicfan.service dynamicfan.timer /etc/systemd/system/
     ```
   - Enable and start the timer:
     ```sh
     sudo systemctl enable fans.timer
     sudo systemctl start fans.timer
     ```

## Usage

The systemd timer will run the `fans.sh` script at the intervals specified in the `dynamicfan.timer` file. Ensure the script has executable permissions:
```sh
chmod +x fans.sh
```

## Disclaimer

I'm not responsible for any overheating or general system breakage from you using this script. You do this at your own risk yadadada.
