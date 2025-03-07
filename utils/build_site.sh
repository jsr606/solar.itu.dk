baseURL="https://solar.itu.dk" 
contentDir="/home/luil/home_page" 
repoDir="/home/luil/solar.itu.dk" 
outputDir="/tmp/solar/"
finalDir="/var/www/test/"

# Check for updates in Git
echo "Checking for updates in $repoDir"

cd "$repoDir" || { echo "Error: Could not change directory to $repoDir"; exit 1; }

updated=$(git pull origin main)

if echo "$updated" | grep -q "Already up to date"; then
    echo "No changes detected. Skipping build."
    exit 0
fi

echo "Git repository updated. Rebuilding the site."

# Build the site
echo "Generating site in temporary directory: $outputDir"
hugo -b "$baseURL" --destination "$outputDir"

# Check if Hugo build succeeded
if [ $? -ne 0 ]; then
    echo "Hugo build failed!"
    exit 1
fi

# Move the built site to the live directory
echo "Deploying site to $finalDir"
sudo mv "$outputDir" "$finalDir"

# Set correct ownership and permissions
sudo chown -R www-data:www-data "$finalDir"
sudo chmod -R g+rw "$finalDir"

echo "Site built and deployed successfully."
