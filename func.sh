# In this file is all my custom functions or commands

# Faster way to run python3 scripts
py () {
	python3 $1
}

# Make a new virtual environment
mkenv () {
	vePath=~/.virtualenvs/
	if [ ! -d $vePath ]; then
		mkdir $vePath
	fi

	if [ "$#" == 0 ]; then
		echo "ERROR:"
		echo "	Please enter an argument"

	elif [ "$#" == 2 ]; then
		fullPath=$vePath$2
		case $1 in
			-n)
				virtualenv -p python3 $fullPath
				source $fullPath/bin/activate
				;;

			-d)
				virtualenv -p python3 $vePath$2
				source $vePath$2
				pip install django
				;;

		esac

	elif  [ "$#" == 1 ]; then
		fullPath=$vePath$1

		virtualenv -p python3 $fullPath
		source $fullPath/bin/activate

	fi
}

clone () {
	if [ $# == 1 ]; then
		git clone git@github.com:joaobartolot/$1.git

	elif [ $# == 2 ]; then
		case $1 in
			-d | --django-project)
				if [ ! -d ~/Projects ]; then
					mkdir ~/Projects
				fi

				if [ ! -d ~/Projects/$2 ]; then
					git clone git@github.com:joaobartolot/$2.git

					cd ~/Projects/$2

					if [ "$VIRTUAL_ENV" == "" ]; then
						if [ ! -d ~/.virtualenvs/$2 ]; then
							virtualenv -p python3 ~/.virtualenvs/$2
							source ~/.virtualenvs/$2

							if [ ! "$VIRTUAL_ENV" == "" ]; then
								pip install django

								if [ -f ./requirements.txt ]; then
									pip install -r requirements.txt
								fi

							else
								echo ""
								echo "*ERROR*"
								echo "	You are not in a virtual environment so we didn't install django"
								echo ""
								
							fi
							

							else
								echo ""
								echo "*ERROR*"
								echo "	This virtual environment already exists"
								echo ""
							fi

						else
							echo ""
							echo "*ERROR*"
							echo "	You are running a virtual environment please deativate and create a new one"
							echo ""
						
						fi
					fi
					;;

		esac

	fi
}
