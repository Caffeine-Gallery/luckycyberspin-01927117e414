import { backend } from 'declarations/backend';

const poemContainer = document.getElementById('poem-container');
const searchInput = document.getElementById('search-input');
const searchButton = document.getElementById('search-button');
const allPoemsButton = document.getElementById('all-poems');
const randomPoemButton = document.getElementById('random-poem');
const poemOfTheDayButton = document.getElementById('poem-of-the-day');

function displayPoem(poem) {
    poemContainer.innerHTML = `
        <article class="poem">
            <h2>${poem.title}</h2>
            <pre>${poem.content}</pre>
        </article>
    `;
}

function displayPoems(poems) {
    poemContainer.innerHTML = poems.map(poem => `
        <article class="poem">
            <h2>${poem.title}</h2>
            <pre>${poem.content}</pre>
        </article>
    `).join('');
}

async function getAllPoems() {
    try {
        const poems = await backend.getAllPoems();
        displayPoems(poems);
    } catch (error) {
        console.error('Error fetching all poems:', error);
    }
}

async function getRandomPoem() {
    try {
        const poem = await backend.getRandomPoem();
        displayPoem(poem);
    } catch (error) {
        console.error('Error fetching random poem:', error);
    }
}

async function getPoemOfTheDay() {
    try {
        const poem = await backend.getPoemOfTheDay();
        displayPoem(poem);
    } catch (error) {
        console.error('Error fetching poem of the day:', error);
    }
}

async function searchPoems() {
    const query = searchInput.value.trim();
    if (query) {
        try {
            const poems = await backend.searchPoems(query);
            displayPoems(poems);
        } catch (error) {
            console.error('Error searching poems:', error);
        }
    }
}

allPoemsButton.addEventListener('click', getAllPoems);
randomPoemButton.addEventListener('click', getRandomPoem);
poemOfTheDayButton.addEventListener('click', getPoemOfTheDay);
searchButton.addEventListener('click', searchPoems);
searchInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        searchPoems();
    }
});

// Load all poems on page load
getAllPoems();
