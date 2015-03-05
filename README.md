# Virus scan daemon

is a demo application for lunching [virus_scan_service gem](https://github.com/equivalent/virus_scan_service)
runners to scan viruses using Kaspersky endponit security (`avp.com` cmd)
on a Windows machine using Ruby.

If you want to use it with Ubuntu Kaspersky endpoint 
use `VirusScanService::KasperskyRunner::LinuxExecutor`
however I've personaly tested only Windows solution.

If you want to use diferent antivirus you can, but you have to 
implement your own runner.

please read more here https://github.com/equivalent/virus_scan_service


## fresh Windows setup

Last time I wrote Ruby scripts for Windows was 7 years ago,
that's why I'll put here entire step-by step guide for
dummies (a.k.a future me)

1. install Kaspersky Endpoint Security and make sure you check 
   `add avp.com to %PATH%` option. I'm not sure if entire endpoint
   security is required, as long as you can run `avp.com`
   from `cmd` to scan virus then you are fine. If `avp.com` is not
   working you need to add it to `%PATH` (http://support.kaspersky.co.uk/7321)
2. install [ruby](http://rubyinstaller.org/) and [git](http://git-scm.com/downloads)
   when asked if you want to include ruby in `%PATH%` tick the box that
   yes you do.
3. in `cmd` run `gem install bundler`. Error may be raised
   due to `rubygems` ssl certificate check
   https://github.com/equivalent/scrapbook2/blob/master/windows.md#solving-the-ssl-error-when-installing-rubygems
   for solution
4. from `gitbash` clone this repo
   `mkdir ~/apps && cd ~/apps && git clone https://github.com/equivalent/virus_scan_daemon.git`
5. from `cmd` cd into clonned dir and run `bundle install`

## Run

from `cmd`

```sh
bundle exec ruby daemon.rb
```

or if you just want to run once

```sh
bundle exec ruby script.rb
```

#### lunch on Windows startup

1. create a `lunch_virus_scaner.bat` (e.g. in: `c:\Users\apps`) and add this into
   it:

   ```
   echo off
   cd %USERPROFILE%\apps\virus_scan_daemon
   bundle exec ruby daemon.rb
   ```

2. add shortuct of it to
   `c:\Users\<loginname>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`

## Log

From `gitbash` you can `tail -f virus_scan_service.log`. By default the
log shows only Error messages. If you want to trace info or debugging
messages just create empty file `info` or `debug` in directory where
you cloned this repo (see the `daemon.rb` for more details).
