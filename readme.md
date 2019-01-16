
# Yandex Contest Manager

`yandex-contest-downloader` is a console application which allows you to download [yandex contest](https://official.contest.yandex.ru) problems

## What
It parses problems from [yandex contest](https://official.contest.yandex.ru) and saves it locally on pc, it generates directories with problems description and files.

It creates something like:
![enter image description here](https://pp.userapi.com/c846523/v846523223/172e8d/-NsmXXcLFXs.jpg)
![enter image description here](https://pp.userapi.com/c846523/v846523223/172e9e/qNuhsN_v5XE.jpg)

  

## Installation

  

First of all, [node.js](https://nodejs.org/en/) must be installed.

Then you should run in console:

  

```bash

npm i -g yandex-contest-downloader

```
  
Or install via `yarn`:

```bash

yarn global add yandex-contest-downloader

```
  

## Usage

  

```bash

ycd --help

```

```bash

Usage: ycd [options]

Options:
  -v, --version                output the version number
  -e, --extension [extension]  Specify file extension (default: "py")
  -u, --username [username]    Specify yandex contest username
  -p, --password [password]    Specify yandex contest password
  -s, --session [session]      Specify yandex contest session
  -i, --id [n]                 Specify yandex contest number
  -R, --no-readme              Do not create readme files
  -d, --domain [domain]        Yandex contest domain (default: "official.contest.yandex.ru")
  -o, --outputDir [dirname]    Output dirname
  -h, --help                   output usage information

```
  

### Example

To load contest problem  

```bash

# it downloads contest problems
ycd --id <id> 

```

In case, when the contest is private:
```bash

# provide username and password
# Note: works only for https://official.contest.yandex.ru
ycd --id <id> -u <username> -p <password> 


# session must be `Contest_Session_Id` cookie from official.contest.yandex.ru
ycd --id <id> -s <session> 

```

Parse config
```bash

 # you can set files extension default is `.py`
ycd --id <id> -e py

# or you can change output directory
ycd --id <id> -o my_contest

# or don't create readme files
ycd --id <id> --no-readme

```


  

## Contributing

  

Bug reports and pull requests are welcome on GitHub at https://github.com/kaikash/yandex-contest-downloader. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

  
  

## License

  

The package is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
