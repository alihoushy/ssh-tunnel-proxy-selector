# SSH Tunnel Proxy Selector

This script allows you to easily establish SSH tunnel proxies to different remote servers with various configurations. It's a convenient way to access restricted or private resources securely through SSH tunnels.

## How to Use

1. Clone the repository to your local machine.
2. Make sure you have `expect` installed. If not, you can install it using your package manager (e.g., `apt`, `brew`, or `yum`).
3. Edit the script to add your server options, including `server name`, `IP address`, `username`, `password`, and `port number`.
4. Make the script executable by running the following command in your terminal:

    ```shell
    chmod +x ./ssh_tunnel_proxy.sh
    ```

5. Run the script using the command: `./ssh_tunnel_proxy.sh`
6. Select the server option you want to use by entering the corresponding number.

## Contributing

If you'd like to contribute to this project, feel free to fork the repository and create a pull request with your improvements.

**Note:** Make sure to keep your username and password information secure and do not share them in your repository. You can use environment variables or other methods to manage credentials more securely.
