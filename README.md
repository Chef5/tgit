# tgit

自封装git（支持macOS/Windows）

功能：

- 克隆项目后，自动设置当前项目的用户名和邮箱，避免和github、gitee等其他托管平台git用户名冲突
- 封装git，自动将参数中的内网ip转为外网ip，无需使用VPN

## 说明

公司要求，提交时用户名需要为本人的名字和公司邮箱，可通过`git config --global`或者`git config --local`进行设置，当全局设置时，你在github、gitee等其他托管平台git提交时，也会是使用的本人的名字和公司邮箱，这可能导致隐私泄露和托管平台无法识别。那我们不用全局设置，给每个项目设置就可以避免该问题，但这又有可能很多时候克隆了公司项目忘记了设置，就很尴尬。

针对上述困扰，我写了个脚本，通过该脚本克隆代码时，会自动在克隆完毕后，设置当前项目的用户名和邮箱。
同时，为了解决外地克隆项目每次总要将项目地址的内网ip替换为外网ip，或者是需要登录vpn的繁琐操作，本脚本也会检测项目地址，将内网地址自动替换为外网地址。

**运行示例**

``` shell
nunet@mbp ~ % tgit clone http://192.168.0.110:9999/project/front-end/vue3-demo.git
tgit: Working...
tgit: Replace with: clone http://223.223.223.223:9999/project/front-end/vue3-demo.git
Cloning into 'vue3-demo'...
remote: Enumerating objects: 121, done.
remote: Counting objects: 100% (121/121), done.
remote: Compressing objects: 100% (84/84), done.
remote: Total 121 (delta 30), reused 94 (delta 18), pack-reused 0
Receiving objects: 100% (121/121), 1.32 MiB | 672.00 KiB/s, done.
Resolving deltas: 100% (30/30), done.
tgit: set local user.name=鲁班大师
tgit: set local user.email=patrick@example.com
tgit: Success!
```

## macOS安装使用

1. 获取脚本

``` shell
cd ~ && git clone https://github.com/Patrick-Jun/tgit.git
```

2. 修改配置

``` shell
vim tgit.sh
```

> 可以使用vscode进行编辑，也许更方便哟

- git_in：内网地址（正则）
- git_out：外网地址
- git_user_name：需要设置的用户名
- git_user_email：需要设置的邮箱

**示例**
``` shell
# git内网地址
git_in='192.168.0.110:[0-9]\{1,5\}'
# git外网地址
git_out='223.223.223.223:9999'

# 用户名和邮箱
git_user_name='鲁班大师'
git_user_email='patrick@example.com'
####################### 配置-end ########################
```

3. 安装命令

``` shell
vim ~/.bash_profile
```

添加一行：

``` shell
alias tgit='bash ~/tgit/tgit.sh'
```

执行命令：

``` shell
source ~/.bash_profile
```

然后，你就可以使用tgit代替git啦！

## Windows安装使用

1. 获取脚本

``` shell
cd ~ && git clone https://github.com/Patrick-Jun/tgit.git
```

2. 修改配置

使用vscode进行编辑`tgit.sh`

- git_in：内网地址（正则）
- git_out：外网地址
- git_user_name：需要设置的用户名
- git_user_email：需要设置的邮箱

**示例**
``` shell
# git内网地址
git_in='192.168.0.110:[0-9]\{1,5\}'
# git外网地址
git_out='223.223.223.223:9999'

# 用户名和邮箱
git_user_name='鲁班大师'
git_user_email='patrick@example.com'
####################### 配置-end ########################
```

3. 编辑git配置文件

因为脚本是shell写的，需要在linux环境下运行，Windows系统需要借助git bash使用命令。

（1）找到本机git安装目录，通常在`C:\Program Files\Git`

（2）复制`tgit.sh`到该目录下

（3）编辑/etc/profile.d/aliases.sh，通常在`C:\Program Files\Git\etc\profile.d\aliases.sh`

添加一行（可能需要管理员权限）：

``` shell
alias tgit='bash /tgit.sh'
```

4. 运行tgit命令
  
每次使用tgit命令的时候，鼠标右键`git bash`，调出小黑框就可以执行`tgit`命令了。
