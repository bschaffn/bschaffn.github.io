D="`date +%Y.%m.%d`"

if [ -n "$1" ]
then
	title=$*
else
	title="new_post_`date +%m.%d_%H:%M:%S`"
fi

filename=`echo "posts/$title.html" | sed "s/[<>:\?\|\{\[\}\}\"\'\(\) ]/_/g"`
display=`echo $title | sed "s/_/ /g"`
list="$D - $display"

echo "$filename"
echo "$list"

if [ ! -e "$filename" ]
then
	verb="created new"
	sed "s/%TITLE/$display/g" template.html > $filename
	command="\$_ .= qq(\t\t\t<li><a href='$filename'>$list</a></li>\n) if /%POST/"

	perl -pi -e "$command" index.html

else
	verb="edited"
fi

vim $filename

message="$verb blog post \"$display\"."
clear
echo $message
git add -A
git commit -m "$message"

while [ "1" -eq "1" ] 
do
	echo "push changes? (Y/n)"

	read person

	case "$person" in
		"Y" )
		echo
		git push origin
		echo "pushed changes."
		break
		;;
		"y" )
		echo
		echo "Y to confirm push"
		;;
		"n" | "N" )
		echo
		echo "did not push changes."
		break
		;;
		* )
		echo
		echo "invalid option"	
	esac
done
