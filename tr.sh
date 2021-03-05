#!/bin/zsh
if [ "$#" -eq 0 ]
then
	read choice\?"Are you searching for a directory (d) or a file (f) "

	if [ "$choice" = d ]
	then
		local dir=`find $HOME -type d | fzf`
		local size=`du -d 0 $dir | awk '{print $1}'`

		if [ "$size" -gt 512000 ]
		then
			echo "Directory is larger than 512MB"
		else

			local toZip=`echo $dir | awk -F'/' '{ print ($NF) }'`
			cd $dir && cd .. && zip -r $dir $toZip
			local out=`curl -F"file=@$dir.zip" 0x0.st`

			read answer\?"Would you like to clean up the zip file? [y|n] "
					
			if [ "$answer" = y ]
			then
				rm "$dir.zip"
			else
				echo "No cleaning done boss"
			fi

			echo "Your link is $out"
		fi

	else
		local out=`curl -F"file=@$(find $HOME -type f | fzf)" 0x0.st`
		echo "Your link is $out"
	fi
else	
	if [ -d $1 ]
	then
		echo -e "Your entry is a directory so it will be zipped\n"
		local size=`du -d 0 $1 | awk '{print $1}'`

		if [ "$size" -gt 512000 ]
		then
			echo "Directory is larger than 512 MB"
		else
			local toZip=`echo $1 | awk -F'/' '{ print ($NF) }'`
			cd $1 && cd .. && zip -r $1 $toZip
			local out=`curl -F"file=@$1.zip" 0x0.st`
					
			read answer\?"Would you like to clean up the zip file? [y|n] "
					
			if [ "$answer" = y ]
			then
				rm "$1.zip"
			else
				echo "No cleaning done boss"
			fi

			echo "Your link is $out"
		fi
			
	else
		local out=`curl -F"file=@$1" 0x0.st`
		echo "Your link is $out"
	fi
fi
