# CompilersBootstrap
Docker image and configurations for Theory of Compilation course

## Рекомендация по системе/пакетам

Рекомендуемая система: [Ubuntu 19.04](http://releases.ubuntu.com/19.04/).  
Можно просто поставить на виртуальную машину и работать в ней целиком. В 2019 году проблем со скоростью работы не должно быть.

Пакеты:
```bash
sudo apt-get update && sudo apt-get install \
    apt-utils gcc g++ openssh-server cmake build-essential gdb gdbserver rsync \
    llvm clang flex bison libclang-8-dev llvm-dev
```
Конечено же, никто не запрещает использовать другим дистрибутивом (или даже OS), *просто* убедитесь, что на ней нормально ставятся и подтягиваются в CMake через find_package() (если вы собираетесь его использовать, что рекоммендуется) Flex >= 2.6 и Bison >= 3.3. 

## Альтернативный сценарий - Docker

Если вы используете [CLion](https://www.jetbrains.com/clion/) в качестве IDE, то можете воспользоваться фичёй Remote Toolchain. Она позволяет собирать и отлаживать проект в удалённой среде, например в Docker-контейнере.
Для того, чтобы настроить эту схему работы:

1. Поставьте [Docker](https://www.docker.com/products/docker-desktop)  
Если вы уже на Linux, воспользуйтесь любимым Packet Manager-ом и прихватите docker-compose.  
Если на Windows - Home Edition, то можно воспользоваться [legacy-версией докера для Винды](https://docs.docker.com/toolbox/toolbox_install_windows/). Эта версия ставит, настраивает и запускает виртуальную машину с сетевым адресом 192.168.99.100. Если вы используйте эту версию докера, везде в дальнейшем заменяйте *localhost* на *192.168.99.100*
2. Склонируйте данный репозиторий. 
3. Соберите и запустите контейнеры:
```bash
# Из директории с docker-compose.yml
docker-compose up -d
```
При наличии проблем, убедитесь, что на вашей машине свободны порты 7776 и 7777.  
4. Настройте CLion в точности, как описано [здесь](https://github.com/shuhaoliu/docker-clion-dev)

## Я очень хочу, чтобы всё собиралось на OS X
1. Поставить рабочий компилятор (например, GCC или CLang из Homebrew), т.к. нативный компилятор плохо работает с общими C++-проектами и зточен под нативные приложения.
2. Настроить переменные окружения
```bash
export CC=<path to compiler, for ex. '/usr/local/opt/gcc/bin/gcc-9'>
export CXX=<path to compiler, for ex. '/usr/local/opt/gcc/bin/g++-9'>
```
Можно записать в ~/.bash_profile, чтобы экспортировать всегда.
3. Библиотеки, которые понадобятся в дальнейшем
```bash
brew install flex bison
 # т.к. OS X - unix-подобный, он идёт с системным и допотопным flex & bison. Можно переписать версии на brew по-умолчанию таким образом или обновить пути в соответствии с файлом osx.env из этой репы
export PATH="/usr/local/opt/flex/bin:$PATH"
export PATH="/usr/local/opt/bison/bin:$PATH"
```
