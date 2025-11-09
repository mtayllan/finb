
# FinB

A simple expense organizer app built with Ruby on Rails and SQLite. This app is designed for personal use, allowing users to track and manage their monthly expenses.


## Features

- **Expense Tracking:** Log your daily expenses and categorize them for better organization.
- **Monthly Overview:** Get a summary of your monthly spending with a clear breakdown of categories.
- **Flexible Deployment:** Run the app locally or deploy it on your favorite cloud platform.


## Setup
- Install [Docker](https://www.docker.com/)
- Clone the repository
```
git clone https://github.com/mtayllan/finb.git
```
- Build the image
```
cd finb
docker build -t finb .
```
- Run
```
docker run -d -p 9090:3000 --name finb -v finb-storage:/rails/storage --env USE_SSL=false --env SECRET_KEY_BASE=1 finb
```
- Access: http://localhost:9090


## License

This project is licensed under the [MIT](https://choosealicense.com/licenses/mit/) License - see the LICENSE file for details.

## Feedback

If you have any feedback, feel free to open a new Issue and we can discuss!

