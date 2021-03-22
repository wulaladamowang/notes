# 使用github
## 目的
借助github托管项目代码
##  基本概念
仓库（Repository）:仓库用来存放项目代码，每个项目对应一个仓库

收藏（Star）：收藏项目方便下次查看

复制克隆项目（Fork）：该项目独立存在

发起请求（pull request）：向源文件发起请求，原作者可以选择合并

关注（Watch）：项目更新，则会收到提醒

食物卡片（issue）：发现代码BUG，但是目前没有成型代码，需要讨论时候用
## 分清概念

Github主页

仓库主页

个人主页

# Git安裝和使用
通过git管理github项目代码

## Git工作区域
工作区 暂存区 git仓库

git status 查看状态

git diff 文件名  查看文件的改动状态，此时文件并未提交到暂存区

git add hello.cpp

git add 文件 将文件提交到暂存区

git commit -m "描述" 将暂存区的文件提交到仓库

git log 显示最近到最远的日志

git log --pretty=oneline 精简显示

git reset --hard HEAD^ 回退到上个版本^增加一个，代表版本继续回退一个

git reset --hard HEAD~n 回退到n个版本之前

git reflog 可以显示包括回退之前的版本

git reset --hard 版本号 通过版本号实现回退到指定的版本

git restore 文件名 撤销更改  
1. 文件修改之前，还没在暂存区，撤销之后和版本库一模一样
2. 文件放在暂存区之后再修改，然后再撤销，会变成和暂存库一致




## git初始化设置

1. 基本信息设置
   1. 设置用户名  git config --global user.name '名称'
   2. 设置用户名邮箱  git config --global user.email 'itcast@itcast.com'
2. 初始化一个新的git仓库
   1. 创建文件夹
   2. 在文件内初始化git  git init 生成.git文件夹

## 创建文件
1. 创建文件
2. git add "文件名"  提交到暂存区
3. git commit -m '描述' 提交到仓库
   
## 修改仓库文件
1. 修改文件
2. 添加文件到暂存区
3. 提交到仓库

**注意时刻用git status查看状态**

## 删除仓库文件
1. 删除文件 rm 文件
2. git rm 文件 删除暂存区文件
3. git commit -m '描述' 删除仓库文件

# Git远程仓库（添加ssh）
备份，共享

现有本地库，后有远程库
   1. git remote add origin git@github.com:wulaladamowang/testgit.git
   2. git branch -M main
   3. git push -u origin main

通过git push origin master 可以将本地master的最新修改推送到github上了




## git克隆的目的
将远程仓库克隆到本地

git clone 仓库地址

git push 将本地仓库同步到远端

# 创建与合并分支
## 创建dev分支，然后切换到dev分支上

git checkout -b dev 创建并切换分支

上述命令等同于下面两个命令

git branch dev； git checkout dev 

git branch  查看所有的分支

git merge 分支名 合并指定分支到当前分支上  fast-forward 模式:将master指向dev

git branch -d 分支名 删除分支

*解决冲突*
通过查看两个不同点 >>>>  <<<<  会标记出不同，通过不同，修改后进行提交

git log . 查看分支合并情况

git merge -no-ff -m "注释" 分支名称 禁用Fast forward 模式

fast forward 模式会使得删除分支后，分支丢失

git log --graph --pretty=oneline --abbrev-commit 查看分支信息

## BUG分支
在遇见bug时候，有了bug可以通过新建临时分支，修复完成之后，然后删除临时分支
1. git stash 保存当前分支现场
2. 首先切换到某个分支，一般是主分支
3. 在主分支上新建分支修复BUG
4. 将新建分支合并到主分支
5. 删除新建分支
6. 切换回工作分支，通过git stash list 可以查看保存的现场
7. 恢复现场的方式
   1. git stash apply 恢复，stash 内容并不会删除，使用git stash drop 来删除
   2. 使用git stash pop 恢复的同时将stash 的内容也删掉

## 多人协作
当从远程库克隆时候，Git会将本地的master分支与远方的master分支进行对应，并且远方库的默认名称是origin

git remote 查看远程库的信息

git remote -v 远程库的详细信息

git remote orgin 分支名 可以将分支信息推送到远程库，同时在远程库新建同名分支

一般同步时候同步master主分支，修复bug的分支通过合并到主分支上进行提交

git branch --set-upstream-to=origin/dev dev 将本地dev与远程origin/dev建立连接

---
# git命令总结
## 新建代码库
git init 在当前目录新建一个代码库

git init [目录] 新建一个目录，并将其初始化为一个代码库

git clone [url] 下载一个项目和他的整个项目历史

## 配置
git config --list 显示当前的git 配置

git config -e [--global] 编辑git配置文件

git config [--global] user.name "[name]"

git config [--global] user.email "[email]"

## 增删文件
git add [file1] [file2] [...]

git add [dir]

git add .

git add -p :添加每一个变化前，会要求确认，对于同一个文件的多处变化，可以实现分次提交

git rm [file1] [file2] [...]

git rm --cached [file] 停止追踪指定文件，但该文件会保存在工作区

git mv [原名] [修改之后名称] 文件改名，提交到暂存区

## 代码提交

git commit -m "注释"

git commit [file1] [file2] [...] -m "注释" 将暂存区的指定文件提交到仓库

git commit -a 提交工作区的变化直接到仓库

git commit -v 提交时显示所有的diff 信息

git commit --amend -m "注释" 使用新一次的提交，代替上一次的commit

git commit --amend [file1] [file2] [...] 重做上一次的commit，并包括指定文件的新变化

## 分支
git branch 

git branch -r 列出所有的远程分支

git branch -a 列出所有的远程分支和本地分支

git branch [新的分支] 新建一个分支不切换

git checkout -b 分支 新建一个分支并切换

git branch [branch] [commit] 新建一个分支，指向指定的commit

git branch --set-upstream-to=origin/dev dev 将本地分支与远程分支链接

git checkout 分支 切换分支

git merge [branch] 合并指定分支到当前分支

git cherry-pick [commit] 选择一个提交，合并到当前分支

git branch -d 分支 删除分支

git push origin --delete [branch-name] 删除远程分支

git branch dr [remote/branch] 删除远程分支

## 标签
git tag 列出所有标签

git tag [tag] 新建一个tag在指定的commit

git tag -d [tag] 删除本地tag

git push origin :refs/tags/[tagname] 删除远程tag

git show [tag] 查看tag信息

git push [remote] [tag] 提交指定tag

git push [remote] --tags 提交所有的tag

git checkout -b [branch] [tag] 新建一个分支，指向某个tag

## 查看信息

git status

git log

git log --stat 显示commit 历史，以及每次commit发生变更的文件

git log -S [keyword] 根据关键词，搜索提交历史

git log [tag] HEAD --pretty=format:%s 显示某个commit之后的所有变动，每个commit占据一行

git log [tag] HEAD --grep feature 显示某个commit之后的所有变动，其"提交说明"必须符合搜索条件


git log --follow [file]

git whatchanged [file] 显示某个文件的版本历史，包括文件改名


git log -p [file] # 显示指定文件相关的每一次diff


git log -5 --pretty --oneline # 显示过去5次提交


git shortlog -sn # 显示所有提交过的用户，按提交次数排序


git blame [file] # 显示指定文件是什么人在什么时间修改过


git diff # 显示暂存区和工作区的差异


git diff --cached [file] # 显示暂存区和上一个commit的差异


git diff HEAD # 显示工作区与当前分支最新commit之间的差异

git diff [first-branch]...[second-branch] # 显示两次提交之间的差异

 
git diff --shortstat "@{0 day ago}" # 显示今天你写了多少行代码

git show [commit] # 显示某次提交的元数据和内容变化

git show --name-only [commit] # 显示某次提交发生变化的文件

git show [commit]:[filename] # 显示某次提交时，某个文件的内容


git reflog # 显示当前分支的最近几次提交

## 远程同步

git fetch [remote] 下载远程仓库的所有变动

git remote -v 显示所有的远程仓库

git remote show [remote] 显示某个远程仓库的信息

git pull [remote] [branch] 取回远程仓库的变化，并与本地仓库进行合并

git push [remote] [branch] 上传本地仓库到远程指定仓库

git push [remote] --force 强行推送，即使有冲突

git checkout [file] 恢复暂存区文件到工作区

git checkout [commit] [file] 恢复某个commit指定文件到暂存区和工作区

git checkout . 恢复所有暂存区文件到工作区

git reset [file] 恢复暂存区指定文件与上一次commit一致，但是工作区不变

git reset --hard 重置暂存区与工作区与上次commit保持一致

git reset [commit] 重置当前分支的指针为指定的commit，同时重置暂存区，但是工作区不变

git reset --hard [commit] 重置当前分支的HEAD为commit,同时重置暂存区与工作区，与指定的commit一致

git reset --keep [commit] 重置当前的HEAD为commit，但是暂存区与工作区都不变

git revert [commit] 新建一个commit，用来撤销指定的commit，后者所有的变化都被前者抵消，并且应用到当前分支

git stash 暂时将未提交的变化移除，稍后再回复现场

git stash pop 恢复现场，并删除