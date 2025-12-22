module.exports = {
  apps: [
    {
      name: 'my_blogs_project',
      script: './.output/server/index.mjs',
      exec_mode: 'cluster',
      instances: '2',
      env: {
        NODE_ENV: 'production',
        PORT: 40080
      }
    }
  ]
}
