#!/bin/bash

# Input
ACTION="${1}" # Action: create-container | add-user
IMAGE="${2:-ubuntu}" # Docker image (default: ubuntu)
CONTAINER_NAME="${3}" # Tên container
USERNAME="${4}" # Username
PASSWORD="${5:-$(tr -dc a-zA-Z0-9 </dev/urandom | head -c 12)}" # Random password nếu không cung cấp
PORT="${6:-$((RANDOM % 40000 + 1025))}" # Random port nếu không cung cấp

# Function: Create a new container
create_container() {
    if [ -z "$CONTAINER_NAME" ]; then
        echo "Container name is required for create-container action."
        exit 1
    fi

    # Create the container
    CONTAINER_ID=$(docker run -d -p "$PORT":22 --name "$CONTAINER_NAME" "$IMAGE" bash -c "apt update && apt install -y openssh-server && mkdir /var/run/sshd && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && service ssh start && while :; do sleep 30; done")

    # Add default user to the container
    docker exec "$CONTAINER_ID" bash -c "useradd -m -s /bin/bash $USERNAME && echo '$USERNAME:$PASSWORD' | chpasswd"

    # Output connection info
    echo "Container created with SSH:"
    echo "Container Name: $CONTAINER_NAME"
    echo "Username: $USERNAME"
    echo "Password: $PASSWORD"
    echo "Port: $PORT"
    echo "Command: ssh $USERNAME@<host-ip> -p $PORT"
}

# Function: Add a user to an existing container
add_user() {
    if [ -z "$CONTAINER_NAME" ] || [ -z "$USERNAME" ]; then
        echo "Container name and username are required for add-user action."
        exit 1
    fi

    # Check if the container is running
    if ! docker ps --filter "name=$CONTAINER_NAME" --format "{{.Names}}" | grep -q "$CONTAINER_NAME"; then
        echo "Error: Container $CONTAINER_NAME is not running."
        exit 1
    fi

    # Add user to container
    docker exec "$CONTAINER_NAME" bash -c "useradd -m -s /bin/bash $USERNAME && echo '$USERNAME:$PASSWORD' | chpasswd"
    echo "User added:"
    echo "Username: $USERNAME"
    echo "Password: $PASSWORD"
    echo "Command: ssh $USERNAME@<host-ip> -p $PORT"
}

# Main logic
case "$ACTION" in
    create-container)
        create_container
        ;;
    add-user)
        add_user
        ;;
    *)
        echo "Invalid action. Use 'create-container' or 'add-user'."
        ;;
esac
