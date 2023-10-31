if [ -d "~/.fzf-conventional-commit" ]; then
  echo "$DIRECTORY does exist."
else
    cp -rf . ~/.fzf-conventional-commit
fi

if grep -Fxq "source ~/.fzf-conventional-commit/function.sh"  ~/.zshrc
then
    echo 'Adready install'
else
    echo "source ~/.fzf-conventional-commit/function.sh"  >> ~/.zshrc
fi
