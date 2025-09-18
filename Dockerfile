FROM node:22

# Install system sqlite3 library and build tools
RUN apt-get update && apt-get install -y \
    sqlite3 \
    libsqlite3-dev \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Force rebuild sqlite3 against system libraries
RUN npm rebuild sqlite3 --build-from-source

# Test that sqlite3 loads correctly
RUN node -e "console.log('Testing sqlite3...'); const sqlite3 = require('sqlite3'); console.log('sqlite3 version:', sqlite3.VERSION); console.log('sqlite3 OK')"

# Copy application code
COPY . .

ENV NODE_ENV=production
EXPOSE 1111
CMD ["npm", "run", "start"]