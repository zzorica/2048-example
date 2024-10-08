# Use the official 2048 Docker image as the base image
FROM amigoscode/2048:latest

# Expose port 80 to access the game
EXPOSE 80

# Command to start the server
CMD ["nginx", "-g", "daemon off;"]
