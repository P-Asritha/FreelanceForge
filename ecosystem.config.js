module.exports = {
  apps: [
    {
      name: 'backend',  // Name of the backend application
      script: './api/server.js',  // Path to the entry point of the backend application
      cwd: './',  // Set the current working directory to the root of the project
      env: {
        NODE_ENV: 'production',  // Set the environment to production
      },
      instances: 'max',  // Use all available CPU cores for scaling
      exec_mode: 'cluster',  // Run the backend in cluster mode for better performance
      watch: true,  // Enable file watching and auto-restart the app if files change
      max_memory_restart: '1G',  // Restart the app if it exceeds 1GB of memory usage
    },
    {
      name: 'frontend',  // Name of the frontend application
      script: 'npm',  // Use npm to start the frontend
      args: 'run start',  // Command to run the frontend app (or 'vite preview' if using Vite)
      cwd: './client',  // Set the working directory to the frontend folder
      env: {
        NODE_ENV: 'production',  // Set the environment to production for the frontend
      },
      instances: 1,  // Run a single instance for the frontend
      exec_mode: 'fork',  // Fork mode, as it’s a single instance
      watch: false,  // Disable file watching for frontend
      max_memory_restart: '1G',  // Restart the frontend app if it exceeds 1GB of memory
    },
  ],
};
