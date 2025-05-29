# 🌐 FileFlow - P2P File Sharing Application 📁

A peer-to-peer file sharing application with integrated chat functionality, allowing users to connect, communicate, and share files directly with each other.

Built with Go and Docker for seamless deployment and cross-platform compatibility.

## ✨ Features

- **👤 User Authentication**: Connect with a username and maintain persistent sessions
- **💬 Real-time Chat**: Send and receive messages with all connected users
- **📁 File Sharing**: Transfer files directly between users
- **📂 Folder Sharing**: Share entire folders with other users
- **🔍 File Discovery**: Look up and browse other users' shared directories
- **🔄 Automatic Reconnection**: Seamlessly reconnect with your existing session
- **👥 Status Tracking**: Monitor which users are currently online
- **🎨 Colorful UI**: Enhanced CLI interface with colors and emojis
- **📊 Progress Bars**: Visual feedback for file and folder transfers
- **🔒 Data Integrity**: MD5 checksum verification for files and folders

## 🚀 Installation

### Prerequisites
- Docker and Docker Compose (recommended) 🐳
- OR Go (1.22.3 or later) 🔧

### Option 1: Using Docker (Recommended) 🐳

1. Clone the repository ⬇️
```bash
git clone https://github.com/YOUR_USERNAME/FileFlow.git
cd FileFlow
```

2. Build and run with Docker Compose 🛠️
```bash
# Start the server and example clients
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

3. Run individual containers 📦
```bash
# Build the Docker image
docker build -t fileflow .

# Run server
docker run -d -p 8080:8080 --name fileflow-server fileflow ./server --port 8080

# Run client (interactive mode)
docker run -it --name fileflow-client1 --link fileflow-server fileflow ./client --server fileflow-server:8080
```

### Option 2: Native Installation (Without Docker) 🔧

1. Clone the repository ⬇️
```bash
git clone https://github.com/YOUR_USERNAME/FileFlow.git
cd FileFlow
```

2. Install dependencies 📦
```bash
go mod download
```

3. Build the application 🛠️
```bash
# Build server
go build -o bin/server ./server/cmd/server.go

# Build client
go build -o bin/client ./client/cmd/client.go
```

## 🎮 Usage

### Using Docker 🐳

#### Starting the Server
```bash
# Using Docker Compose
docker-compose up fileflow-server

# Using Docker directly
docker run -d -p 8080:8080 --name fileflow-server fileflow ./server --port 8080

# Custom port
docker run -d -p 3000:3000 --name fileflow-server fileflow ./server --port 3000
```

#### Connecting as a Client
```bash
# Using Docker Compose (interactive mode)
docker-compose run --rm fileflow-client1

# Using Docker directly
docker run -it --link fileflow-server --name fileflow-client \
  -v $(pwd)/shared:/root/shared \
  fileflow ./client --server fileflow-server:8080

# Connect to remote server
docker run -it --name fileflow-client \
  -v $(pwd)/shared:/root/shared \
  fileflow ./client --server 192.168.0.203:8080
```

### Using Native Binaries 🔧

#### Starting the Server 🖥️
```bash
# Start server on default port 8080
go run ./server/cmd/server.go --port 8080

# Or use the built binary
./bin/server --port 8080

# Start server on custom port
./bin/server --port 3000
```

#### Connecting as a Client 📱
```bash
# Connect to local server
go run ./client/cmd/client.go --server localhost:8080

# Or use the built binary
./bin/client --server localhost:8080

# Connect to remote server
./bin/client --server 192.168.0.203:8080
```

### Application Validation ✅
The application will automatically validate:
- Server availability before client connection attempts
- Port availability before starting a server
- Existence of shared folder paths

## 🏗️ Architecture

The application follows a hybrid P2P architecture:
- 🌐 A central server handles user registration, discovery, and connection brokering
- ↔️ File and folder transfers occur directly between peers
- 💓 Server maintains connection status through regular heartbeat checks

## 📝 Commands

### Chat Commands 💬
| Command | Description |
|---------|-------------|
| `/help` | Show all available commands |
| `/status` | Show online users |
| `exit` | Disconnect and exit the application |

### File Operations 📂
| Command | Description |
|---------|-------------|
| `/lookup <userId>` | Browse user's shared files |
| `/sendfile <userId> <filePath>` | Send a file to another user |
| `/sendfolder <userId> <folderPath>` | Send a folder to another user |
| `/download <userId> <filename>` | Download a file from another user |

## Terminal UI Features 🎨

- 🌈 **Color-coded messages**:
  - Commands appear in blue
  - Success messages appear in green
  - Error messages appear in red
  - User status notifications in yellow
  
- 📊 **Progress bars for file transfers**:
  ```
  [===================================>------] 75% (1.2 MB/1.7 MB)
  ```

- 📁 **Improved file listings**:
  ```
  === FOLDERS ===
  📁 [FOLDER] documents (Size: 0 bytes)
  📁 [FOLDER] images (Size: 0 bytes)
  
  === FILES ===
  📄 [FILE] document.pdf (Size: 1024 bytes)
  📄 [FILE] image.jpg (Size: 2048 bytes)
  ```

## 🔒 Security

The application implements basic reconnection security by tracking IP addresses and user sessions.

- **📁 Folder Path Validation**: The application verifies that shared folder paths exist before establishing a connection. If an invalid path is provided, the user will be prompted to enter a valid folder path.
- **🔌 Server Availability Check**: Client automatically verifies server availability before attempting connection, preventing connection errors.
- **🚫 Port Conflict Prevention**: Server detects if a port is already in use and alerts the user to choose another port.
- **🔐 Checksum Verification**: All file and folder transfers include MD5 checksum calculation to verify data integrity:
  - When sending, a unique MD5 hash is calculated for the file/folder contents
  - During transfer, the hash is securely transmitted alongside the data
  - Upon receiving, a new hash is calculated from the received data
  - The application compares both hashes to confirm the transfer was successful and uncorrupted
  - Users receive visual confirmation of integrity checks with clear success/failure messages

This checksum process ensures that files and folders arrive exactly as they were sent, protecting against data corruption during transfer.

## 🐳 Docker Architecture

FileFlow uses a multi-stage Docker build for optimized image size:
- **Build Stage**: Compiles Go binaries with all dependencies
- **Runtime Stage**: Minimal Alpine Linux image with only the compiled binaries
- **Network**: Bridge network for container communication
- **Volumes**: Persistent storage for shared files

### Docker Benefits
- ✅ Consistent environment across all platforms
- ✅ Easy deployment and scaling
- ✅ Isolated file storage per client
- ✅ No need to install Go locally
- ✅ Quick setup with docker-compose

## 📊 Project Structure
```
FileFlow/
├── client/
│   ├── cmd/
│   │   └── client.go          # Client entry point
│   └── internal/
│       ├── connection.go       # Connection handling
│       ├── file.go            # File operations
│       ├── folder.go          # Folder operations
│       └── transfer.go        # Transfer management
├── server/
│   ├── cmd/
│   │   └── server.go          # Server entry point
│   ├── interfaces/
│   │   └── interfaces.go      # Data structures
│   └── internal/
│       ├── connection.go       # Connection handling
│       ├── file.go            # File operations
│       └── folder.go          # Folder operations
├── helper/
│   └── helper.go              # Utility functions
├── utils/
│   └── ui.go                  # UI components
├── Dockerfile                  # Docker build configuration
├── docker-compose.yml         # Multi-container setup
├── .dockerignore              # Docker ignore rules
├── go.mod                     # Go dependencies
└── README.md                  # Documentation
```

Made with ❤️ by the FileFlow Team
