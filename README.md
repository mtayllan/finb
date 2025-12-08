
# FinB

A simple expense organizer app built with Ruby on Rails and SQLite. This app is designed for personal use, allowing users to track and manage their monthly expenses.


## Features

- **Expense Tracking:** Log your daily expenses and categorize them for better organization.
- **Monthly Overview:** Get a summary of your monthly spending with a clear breakdown of categories.
- **Flexible Deployment:** Run the app locally or deploy it on your favorite cloud platform.


## Setup

### Prerequisites
- **For Local Development:**
  - Ruby 3.3+
  - SQLite 3
  - Bundler gem
- **For Docker Deployment:**
  - [Docker](https://www.docker.com/)

### Local Development Setup

1. Clone the repository:
```bash
git clone https://github.com/mtayllan/finb.git
cd finb
```

2. Install dependencies:
```bash
bundle install
```

3. Setup the database:
```bash
bin/rails db:setup
```

4. Start the development server:
```bash
bin/dev
```

5. Access the application at http://localhost:3000

### Docker Deployment

1. Clone the repository:
```bash
git clone https://github.com/mtayllan/finb.git
cd finb
```

2. Build the Docker image:
```bash
docker build -t finb .
```

3. Run the container:
```bash
docker run \
  -d -p 9090:3000 \
  --name finb \
  -v finb-storage:/rails/storage \
  --env SECRET_KEY_BASE=$YOUR_SECRET_KEY_BASE \
  --env USE_SSL=false \
  finb
```

4. Access the application at http://localhost:9090

**Note:** Generate a secret key base with `bin/rails secret` and replace `$YOUR_SECRET_KEY_BASE` with the generated value.

### Updating Docker Deployment

1. Pull the latest changes:
```bash
git pull origin main
```

2. Rebuild the Docker image:
```bash
docker build -t finb .
```

3. Stop and remove the old container:
```bash
docker stop finb
docker rm finb
```

4. Start the new container using the same `docker run` command from step 3 above.


## License

This project is licensed under the [MIT](https://choosealicense.com/licenses/mit/) License - see the LICENSE file for details.

## Feedback

If you have any feedback, feel free to open a new Issue and we can discuss!

