echo Update Upgrade apt
sudo apt update
sudo apt upgrade -y

echo Installing requiered tools
sudo apt install build-essential -y

echo Installing Plant UML ...
sudo apt install plantuml -y
sudo apt install graphviz -y
sudo apt install librsvg2-bin -y

echo Installing LaTeX Package ...
sudo apt install texlive-latex-base -y
sudo apt install texlive-latex-extra -y
sudo apt install texlive-font-utils -y
sudo apt install texlive-lang-french -y
sudo apt install texlive-lang-english -y
sudo apt install biber -y
sudo apt install texlive-bibtex-extra -y
sudo apt install python3-pygments -y
sudo apt install latexmk -y

echo Installing node package
sudo apt install curl -y
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --latest-npm
nvm install node

echo Setup npm folder
cd conception/animUML/conceptionGenerale
npm install