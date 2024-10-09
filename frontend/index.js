import { backend } from 'declarations/backend';

let isLoggedIn = false;
let userBalance = 0;

document.getElementById('login-button').addEventListener('click', login);
document.getElementById('play-button').addEventListener('click', playGame);
document.getElementById('deposit-button').addEventListener('click', deposit);
document.getElementById('withdraw-button').addEventListener('click', withdraw);

async function login() {
    try {
        const result = await backend.login();
        if ('ok' in result) {
            isLoggedIn = true;
            userBalance = result.ok.balance;
            updateUI();
            loadGameHistory();
        } else {
            alert('Login failed: ' + result.err);
        }
    } catch (error) {
        console.error('Login error:', error);
    }
}

async function playGame() {
    if (!isLoggedIn) {
        alert('Please login first');
        return;
    }

    const betAmount = parseFloat(document.getElementById('bet-amount').value);
    if (isNaN(betAmount) || betAmount <= 0) {
        alert('Please enter a valid bet amount');
        return;
    }

    try {
        const result = await backend.playGame(betAmount);
        if ('ok' in result) {
            const gameResult = result.ok;
            userBalance += gameResult.winnings;
            updateUI();
            displayGameResult(gameResult);
            loadGameHistory();
        } else {
            alert('Game failed: ' + result.err);
        }
    } catch (error) {
        console.error('Game error:', error);
    }
}

async function deposit() {
    if (!isLoggedIn) {
        alert('Please login first');
        return;
    }

    const amount = parseFloat(document.getElementById('deposit-amount').value);
    if (isNaN(amount) || amount <= 0) {
        alert('Please enter a valid deposit amount');
        return;
    }

    try {
        const result = await backend.deposit(amount);
        if ('ok' in result) {
            userBalance = result.ok;
            updateUI();
            alert('Deposit successful');
        } else {
            alert('Deposit failed: ' + result.err);
        }
    } catch (error) {
        console.error('Deposit error:', error);
    }
}

async function withdraw() {
    if (!isLoggedIn) {
        alert('Please login first');
        return;
    }

    const amount = parseFloat(document.getElementById('withdraw-amount').value);
    if (isNaN(amount) || amount <= 0) {
        alert('Please enter a valid withdraw amount');
        return;
    }

    try {
        const result = await backend.withdraw(amount);
        if ('ok' in result) {
            userBalance = result.ok;
            updateUI();
            alert('Withdrawal successful');
        } else {
            alert('Withdrawal failed: ' + result.err);
        }
    } catch (error) {
        console.error('Withdrawal error:', error);
    }
}

async function loadGameHistory() {
    try {
        const result = await backend.getGameHistory();
        if ('ok' in result) {
            displayGameHistory(result.ok);
        } else {
            console.error('Failed to load game history:', result.err);
        }
    } catch (error) {
        console.error('Game history error:', error);
    }
}

function updateUI() {
    document.getElementById('login-section').style.display = isLoggedIn ? 'none' : 'block';
    document.getElementById('game-section').style.display = isLoggedIn ? 'block' : 'none';
    document.getElementById('balance').textContent = userBalance.toFixed(2);
}

function displayGameResult(gameResult) {
    const resultElement = document.getElementById('game-result');
    resultElement.textContent = `Bet: $${gameResult.bet.toFixed(2)}, Outcome: ${gameResult.outcome ? 'Win' : 'Loss'}, Winnings: $${gameResult.winnings.toFixed(2)}`;
}

function displayGameHistory(history) {
    const historyElement = document.getElementById('game-history');
    historyElement.innerHTML = '';
    history.forEach((game) => {
        const li = document.createElement('li');
        li.textContent = `Bet: $${game.bet.toFixed(2)}, Outcome: ${game.outcome ? 'Win' : 'Loss'}, Winnings: $${game.winnings.toFixed(2)}`;
        historyElement.appendChild(li);
    });
}

updateUI();
