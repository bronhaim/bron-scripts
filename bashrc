# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

. /usr/share/git-core/contrib/completion/git-prompt.sh

# User specific aliases and functions
#PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '
PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[32m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '
CDPATH=:$HOME
#. /etc/bash_completion.d/sshcon
alias ..="cd .."
alias ....="cd ..; cd .."
alias ......="cd ..; cd ..; cd .."
export CXX=/usr/bin/c++
alias javasdk=/home/ybronhei/Apps/idea-IC-139.1117.1/bin/idea.sh
alias websdk=/home/ybronhei/Apps/WebStorm-141.506/bin/webstorm.sh
export PATH=~/android-studio:~/Apps/node-v0.12.2-linux-x64/bin:$PATH
export JBOSS_HOME=/usr/share/wildfly
#export JBOSS_HOME=/usr/share/jboss-as-7.1.1.Final/
#export JBOSS_HOME=/home/ybronhei/Apps/jboss-eap-6.0
export OVIRT_HOME=/home/ybronhei/Projects/ovirt-engine
export OVIRT_GUI=$OVIRT_HOME/frontend/webadmin/modules/webadmin
#export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.71-1.b15.fc23.x86_64/jre
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.77-1.b03.fc23.x86_64/
export IDEA_JDK=/usr/java/jdk1.8.0_45
export INTELLIJ=/home/ybronhei/Apps/ideaIU/idea-IU-129.713/bin
export MAVEN_OPTS="-XX:MaxPermSize=128m"
export MY_OVIRT=~/Projects/ovirt-engine/
export MY_VDSM=~/Projects/vdsm-upstream/
export ENGINE_ETC=/usr/share/jboss-as-7.1.1.Final/standalone/configuration
export INST_HOME=/home/ybronhei/ovirt-enginush
export GIT_EDITOR=vim
alias logvdsm="vim -f /var/log/vdsm/vdsm.log"
alias mooo="mvn clean install -D skipTests"
alias sleep="sudo pm-suspend"
alias eclipse="/home/ybronhei/Apps/eclipse/eclipse"
alias n4mount="simple-mtpfs /home/ybronhei/Misc/Nexus4"
alias n4umount="fusermount -u /home/ybronhei/Misc/Nexus4"
alias n4folder="cd /home/ybronhei/Misc/Nexus4"
alias cengine="make clean install-dev PREFIX=$HOME/ovirt-engine EXTRA_BUILD_FLAGS_DEV='Dgwt-plugin.localWorkers=2'"
alias cengine-tests="make clean install-dev PREFIX=$HOME/ovirt-engine EXTRA_BUILD_FLAGS_DEV='-Dgwt-plugin.localWorkers=2' BUILD_UT=1"
alias tellme='notify-send -a "compilation compeleted" -t 5 "Done with compilation"'
#alias idea='nohup ~/idea `pwd` >& /dev/null &'
alias bashrc='vim ${HOME}/.bashrc;. ${HOME}/.bashrc'
alias sdn_1='pacmd set-sink-volume 0 0x28000'
alias sdn_2='pacmd set-sink-volume 0 0x20000'
alias study='cd ~/Documents/study'


# alias for puppet course
export VAGRANT_DEFAULT_PROVIDER=libvirt
alias vs='vagrant status'
alias vp='vagrant provision'
alias vup='vagrant up'
alias vssh='vagrant ssh'
alias vdestroy='vagrant destroy'
function vlog {
	VAGRANT_LOG=info vagrant "$@" 2> vagrant.log
}
# vagrant sftp
function vsftp {
	[ "$1" = '' ] || [ "$2" != '' ] && echo "Usage: vsftp <vm-name> - vagrant sftp" 1>&2 && return 1
	wd=`pwd`		# save wd, then find the Vagrant project
	while [ "`pwd`" != '/' ] && [ ! -e "`pwd`/Vagrantfile" ] && [ ! -d "`pwd`/.vagrant/" ]; do
		#echo "pwd is `pwd`"
		cd ..
	done
	pwd=`pwd`
	cd $wd
	if [ ! -e "$pwd/Vagrantfile" ] || [ ! -d "$pwd/.vagrant/" ]; then
		echo 'Vagrant project not found!' 1>&2 && return 2
	fi

	d="$pwd/.ssh"
	f="$d/$1.config"

	# if mtime of $f is > than 5 minutes (5 * 60 seconds), re-generate...
	if [ `date -d "now - $(stat -c '%Y' "$f" 2> /dev/null) seconds" +%s` -gt 300 ]; then
		mkdir -p "$d"
		# we cache the lookup because this command is slow...
		vagrant ssh-config "$1" > "$f" || rm "$f"
	fi
	[ -e "$f" ] && sftp -F "$f" "$1"
}

# vagrant screen
function vscreen {
	[ "$1" = '' ] || [ "$2" != '' ] && echo "Usage: vscreen <vm-name> - vagrant screen" 1>&2 && return 1
	wd=`pwd`		# save wd, then find the Vagrant project
	while [ "`pwd`" != '/' ] && [ ! -e "`pwd`/Vagrantfile" ] && [ ! -d "`pwd`/.vagrant/" ]; do
		#echo "pwd is `pwd`"
		cd ..
	done
	pwd=`pwd`
	cd $wd
	if [ ! -e "$pwd/Vagrantfile" ] || [ ! -d "$pwd/.vagrant/" ]; then
		echo 'Vagrant project not found!' 1>&2 && return 2
	fi

	d="$pwd/.ssh"
	f="$d/$1.config"
	h="$1"
	# hostname extraction from user@host pattern
	p=`expr index "$1" '@'`
	if [ $p -gt 0 ]; then
		let "l = ${#h} - $p"
		h=${h:$p:$l}
	fi

	# if mtime of $f is > than 5 minutes (5 * 60 seconds), re-generate...
	if [ `date -d "now - $(stat -c '%Y' "$f" 2> /dev/null) seconds" +%s` -gt 300 ]; then
		mkdir -p "$d"
		# we cache the lookup because this command is slow...
		vagrant ssh-config "$h" > "$f" || rm "$f"
	fi
	[ -e "$f" ] && ssh -t -F "$f" "$1" 'screen -xRR'
}

# vagrant cssh
function vcssh {
	[ "$1" = '' ] && echo "Usage: vcssh [options] [user@]<vm1>[ [user@]vm2[ [user@]vmN...]] - vagrant cssh" 1>&2 && return 1
	wd=`pwd`		# save wd, then find the Vagrant project
	while [ "`pwd`" != '/' ] && [ ! -e "`pwd`/Vagrantfile" ] && [ ! -d "`pwd`/.vagrant/" ]; do
		#echo "pwd is `pwd`"
		cd ..
	done
	pwd=`pwd`
	cd $wd
	if [ ! -e "$pwd/Vagrantfile" ] || [ ! -d "$pwd/.vagrant/" ]; then
		echo 'Vagrant project not found!' 1>&2 && return 2
	fi

	d="$pwd/.ssh"
	cssh="$d/cssh"
	cmd=''
	cat='cat '
	screen=''
	options=''

	multi='f'
	special=''
	for i in "$@"; do	# loop through the list of hosts and arguments!
		#echo $i

		if [ "$special" = 'debug' ]; then	# optional arg value...
			special=''
			if [ "$1" -ge 0 -o "$1" -le 4 ]; then
				cmd="$cmd $i"
				continue
			fi
		fi

		if [ "$multi" = 'y' ]; then	# get the value of the argument
			multi='n'
			cmd="$cmd '$i'"
			continue
		fi

		if [ "${i:0:1}" = '-' ]; then	# does argument start with: - ?

			# build a --screen option
			if [ "$i" = '--screen' ]; then
				screen=' -o RequestTTY=yes'
				cmd="$cmd --action 'screen -xRR'"
				continue
			fi

			if [ "$i" = '--debug' ]; then
				special='debug'
				cmd="$cmd $i"
				continue
			fi

			if [ "$i" = '--options' ]; then
				options=" $i"
				continue
			fi

			# NOTE: commented-out options are probably not useful...
			# match for key => value argument pairs
			if [ "$i" = '--action' -o "$i" = '-a' ] || \
			[ "$i" = '--autoclose' -o "$i" = '-A' ] || \
			#[ "$i" = '--cluster-file' -o "$i" = '-c' ] || \
			#[ "$i" = '--config-file' -o "$i" = '-C' ] || \
			#[ "$i" = '--evaluate' -o "$i" = '-e' ] || \
			[ "$i" = '--font' -o "$i" = '-f' ] || \
			#[ "$i" = '--master' -o "$i" = '-M' ] || \
			#[ "$i" = '--port' -o "$i" = '-p' ] || \
			#[ "$i" = '--tag-file' -o "$i" = '-c' ] || \
			[ "$i" = '--term-args' -o "$i" = '-t' ] || \
			[ "$i" = '--title' -o "$i" = '-T' ] || \
			[ "$i" = '--username' -o "$i" = '-l' ] ; then
				multi='y'	# loop around to get second part
				cmd="$cmd $i"
				continue
			else			# match single argument flags...
				cmd="$cmd $i"
				continue
			fi
		fi

		f="$d/$i.config"
		h="$i"
		# hostname extraction from user@host pattern
		p=`expr index "$i" '@'`
		if [ $p -gt 0 ]; then
			let "l = ${#h} - $p"
			h=${h:$p:$l}
		fi

		# if mtime of $f is > than 5 minutes (5 * 60 seconds), re-generate...
		if [ `date -d "now - $(stat -c '%Y' "$f" 2> /dev/null) seconds" +%s` -gt 300 ]; then
			mkdir -p "$d"
			# we cache the lookup because this command is slow...
			vagrant ssh-config "$h" > "$f" || rm "$f"
		fi

		if [ -e "$f" ]; then
			cmd="$cmd $i"
			cat="$cat $f"	# append config file to list
		fi
	done

	cat="$cat > $cssh"
	#echo $cat
	eval "$cat"			# generate combined config file

	#echo $cmd && return 1
	#[ -e "$cssh" ] && cssh --options "-F ${cssh}$options" $cmd
	# running: bash -c glues together --action 'foo --bar' type commands...
	[ -e "$cssh" ] && bash -c "cssh --options '-F ${cssh}${screen}$options' $cmd"
}

# vagrant forward (ssh -L)
function vfwd {
	[ "$1" = '' ] || [ "$2" = '' ] && echo "Usage: vfwd <vm-name> hostport:guestport [hostport:guestport] - vagrant ssh forward" 1>&2 && return 1
	wd=`pwd`		# save wd, then find the Vagrant project
	while [ "`pwd`" != '/' ] && [ ! -e "`pwd`/Vagrantfile" ] && [ ! -d "`pwd`/.vagrant/" ]; do
		#echo "pwd is `pwd`"
		cd ..
	done
	pwd=`pwd`
	cd $wd
	if [ ! -e "$pwd/Vagrantfile" ] || [ ! -d "$pwd/.vagrant/" ]; then
		echo 'Vagrant project not found!' 1>&2 && return 2
	fi

	d="$pwd/.ssh"
	f="$d/$1.config"
	h="$1"
	# hostname extraction from user@host pattern
	p=`expr index "$1" '@'`
	if [ $p -gt 0 ]; then
		let "l = ${#h} - $p"
		h=${h:$p:$l}
	fi

	# if mtime of $f is > than 5 minutes (5 * 60 seconds), re-generate...
	if [ `date -d "now - $(stat -c '%Y' "$f" 2> /dev/null) seconds" +%s` -gt 300 ]; then
		mkdir -p "$d"
		# we cache the lookup because this command is slow...
		vagrant ssh-config "$h" > "$f" || rm "$f"
	fi

	name="$1"
	shift	# pop off the vmname
	fwd=()	# array
	cmd='ssh'
	for x in "${@}"
	do
		#echo "pair: $x"
		port=`echo "$x" | awk -F ':' '{print $1}'`
		if [ "$port" -le 1024 ]; then
			cmd='sudo ssh'	# sudo needed for < 1024
		fi
		b=`echo "$x" | awk -F ':' '{print "-L "$1":localhost:"$2}'`
		fwd+=("$b")	# append
	done
	echo ${fwd[@]}	# show the -L commands
	[ -e "$f" ] && $cmd -N -F "$f" root@"$name" "${fwd[@]}"
}

function cdmkdir {
	mkdir $1
	cd $1
}


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
eval $(thefuck --alias)
