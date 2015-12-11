# Dropbox Uploader

Dropbox Uploader is a **BASH** script which can be used to upload, download, delete, list files (and more!) from **Dropbox**, an online file sharing, synchronization and backup service.

It's written in BASH scripting language and only needs **cURL**.

**Why use this script?**

* **Portable:** It's written in BASH scripting and only needs *cURL* (curl is a tool to transfer data from or to a server, available for all operating systems and installed by default in many linux distributions).
* **Secure:** It's not required to provide your username/password to this script, because it uses the official Dropbox API for the authentication process.

Please refer to the &lt;Wiki&gt;(https://github.com/andreafabrizi/Dropbox-Uploader/wiki) for tips and additional information about this project. The Wiki is also the place where you can share your scripts and examples related to Dropbox Uploader.

## Features

* Cross platform
* Support for the official Dropbox API
* No password required or stored
* Simple step-by-step configuration wizard
* Simple and chunked file upload
* File and recursive directory download
* File and recursive directory upload
* Shell wildcard expansion (only for upload)
* Delete/Move/Rename/Copy/List files
* Create share link

## Getting started

First, clone the repository using git (recommended):

```bash
git clone https://github.com/andreafabrizi/Dropbox-Uploader/
```

or download the script manually using this command:

```bash
curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh
```

Then give the execution permission to the script and run it:

```bash
 $chmod +x dropbox_uploader.sh
 $./dropbox_uploader.sh
```

The first time you run `dropbox_uploader`, you'll be guided through a wizard in order to configure access to your Dropbox. This configuration will be stored in `~/.dropbox_uploader`.

### Configuration wizard

The configuration wizard is pretty self-explanatory. One thing to notice is that if you choose "App permission", your uploads will end up on Dropbox under an `App/<your_app_name>` folder. To have them stored in another folder, such as in `/dir/`, you'll need to give Dropbox-Uploader permission to all Dropbox files.

## Usage

The syntax is quite simple:

```
./dropbox_uploader.sh COMMAND [PARAMETERS]...

[%%]: Optional param
<%%>: Required param
```

**Available commands:**

* **upload** &lt;LOCAL_FILE/DIR ...&gt; &lt;REMOTE_FILE/DIR&gt;  
Upload a local file or directory to a remote Dropbox folder.  
If the file is bigger than 150Mb the file is uploaded using small chunks (default 4Mb);
in this case a . (dot) is printed for every chunk successfully uploaded and a * (star) if an error
occurs (the upload is retried for a maximum of three times).
Only if the file is smaller than 150Mb, the standard upload API is used, and if the -p option is used
the default curl progress bar is displayed during the upload process.  
The local file/dir parameter supports wildcards expansion.

* **download** &lt;REMOTE_FILE/DIR&gt; [LOCAL_FILE/DIR]  
Download file or directory from Dropbox to a local folder

* **delete** &lt;REMOTE_FILE/DIR&gt;  
Remove a remote file or directory from Dropbox

* **move** &lt;REMOTE_FILE/DIR&gt; &lt;REMOTE_FILE/DIR&gt;  
Move or rename a remote file or directory

* **copy** &lt;REMOTE_FILE/DIR&gt; &lt;REMOTE_FILE/DIR&gt;  
Copy a remote file or directory

* **mkdir** &lt;REMOTE_DIR&gt;  
Create a remote directory on DropBox

* **list** [REMOTE_DIR]  
List the contents of the remote Dropbox folder

* **share** &lt;REMOTE_FILE&gt;  
Get a public share link for the specified file or directory

* **saveurl** &lt;URL&gt; &lt;REMOTE_DIR&gt;  
Download a file from an URL to a Dropbox folder directly (the file is NOT downloaded locally)

* **info**  
Print some info about your Dropbox account

* **unlink**  
Unlink the script from your Dropbox account


**Optional parameters:**  
* **-f &lt;FILENAME&gt;**  
Load the configuration file from a specific file

* **-s**  
Skip already existing files when download/upload. Default: Overwrite

* **-d**  
Enable DEBUG mode

* **-q**  
Quiet mode. Don't show progress meter or messages

* **-h**  
Show file sizes in human readable format

* **-p**  
Show cURL progress meter

* **-k**  
Doesn't check for SSL certificates (insecure)


**Examples:**
```bash
    ./dropbox_uploader.sh upload /etc/passwd /myfiles/passwd.old
    ./dropbox_uploader.sh upload *.zip /
    ./dropbox_uploader.sh download /backup.zip
    ./dropbox_uploader.sh delete /backup.zip
    ./dropbox_uploader.sh mkdir /myDir/
    ./dropbox_uploader.sh upload "My File.txt" "My File 2.txt"
    ./dropbox_uploader.sh share "My File.txt"
    ./dropbox_uploader.sh list
```

## Tested Environments

* GNU Linux
* FreeBSD 8.3/10.0
* MacOSX
* Windows/Cygwin
* Raspberry Pi
* QNAP
* iOS
* OpenWRT
* Chrome OS
* OpenBSD

If you have successfully tested this script on others systems or platforms please let me know!

## Running as cron job
Dropbox Uploader relies on a different configuration file for each system user. The default configuration file location is HOME_DIRECTORY/.dropbox_uploader. This means that if you do the setup with your user and then you try to run a cron job as root, it won't works.  
So, when running this script using cron, please keep in mind the following:
* Remember to setup the script with the user used to run the cron job
* Use always the -f option to specify the full configuration file path, because sometimes in the cron environment the home folder path is not detected correctly
* My advice is, for security reasons, to not share the same configuration file with different users

## How to setup a proxy

To use a proxy server, just set the **https_proxy** environment variable:

**Linux:**
```bash
    export HTTP_PROXY_USER=XXXX
    export HTTP_PROXY_PASSWORD=YYYY
    export https_proxy=http://192.168.0.1:8080
```

**BSD:**
```bash
    setenv HTTP_PROXY_USER XXXX
    setenv HTTP_PROXY_PASSWORD YYYY
    setenv https_proxy http://192.168.0.1:8080
```

## BASH and Curl installation

**Debian & Ubuntu Linux:**
```bash
    sudo apt-get install bash (Probably BASH is already installed on your system)
    sudo apt-get install curl
```

**BSD:**
```bash
    cd /usr/ports/shells/bash && make install clean
    cd /usr/ports/ftp/curl && make install clean
```

**Cygwin:**  
You need to install these packages:  
* curl
* ca-certificates
* dos2unix

Before running the script, you need to convert it using the dos2unix command.


**Build cURL from source:**
* Download the source tarball from http://curl.haxx.se/download.html
* Follow the INSTALL instructions

## DropShell

DropShell is an interactive DropBox shell, based on DropBox Uploader:

```bash
DropShell v0.2
The Intractive Dropbox SHELL
Andrea Fabrizi - andrea.fabrizi@gmail.com

Type help for the list of the available commands.

andrea@Dropbox:/$ ls
 [D] 0       Apps
 [D] 0       Camera Uploads
 [D] 0       Public
 [D] 0       scripts
 [D] 0       Security
 [F] 105843  notes.txt
andrea@DropBox:/ServerBackup$ get notes.txt
```

## Donations

 If you want to support this project, please consider donating:
 * PayPal: andrea.fabrizi@gmail.com
 * BTC: 1JHCGAMpKqUwBjcT3Kno9Wd5z16K6WKPqG

## Examples

curl -s --show-error --globoff -i --data-urlencode "url=https://r13---sn-o097znee.googlevideo.com/videoplayback?expire=1449838320&initcwndbps=2082500&ipbits=0&ratebypass=yes&nh=IgpwcjAxLnBhbzAzKgkxMjcuMC4wLjE&mime=video%2Fmp4&fexp=9416126%2C9418204%2C9419444%2C9419887%2C9420452%2C9420736%2C9421733%2C9422596%2C9423282%2C9423662%2C9423785%2C9424319%2C9425209%2C9425428%2C9425749%2C9426047%2C9426056&upn=JsWuQzILeOo&source=youtube&sparams=dur%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cnh%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cupn%2Cexpire&dur=474.964&id=o-AM4zQbAWPNvmx-yhRCNKOHaljBQUJUu4oWmePwSSIe0Q&itag=22&lmt=1447433774381613&requiressl=yes&ip=67.164.7.245&signature=AA6E8E8329EF2F5A4562DF6793C986A7025C42B0.A735DDD939727C56C472C9AB4619F25641FCF0DF&mv=m&pl=17&mt=1449816672&ms=au&mn=sn-o097znee&mm=31&key=yt6&sver=3" --data "oauth_consumer_key=ty6ns268utylw0q&oauth_token=mk0500nql74pkhag&oauth_signature_method=PLAINTEXT&oauth_signature=465q1ig1n5h7ja2%26g1zu7oad7khuo86&oauth_timestamp=1449816322&oauth_nonce=27155" "https://api.dropbox.com/1/save_url/auto/foo.mp4" 2> /dev/null
