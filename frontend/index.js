import { backend } from 'declarations/backend';

const shoppingList = document.getElementById('shopping-list');
const addItemForm = document.getElementById('add-item-form');
const newItemInput = document.getElementById('new-item');

async function loadItems() {
    const items = await backend.getItems();
    shoppingList.innerHTML = '';
    items.forEach(item => {
        const li = document.createElement('li');
        li.innerHTML = `
            <span class="${item.completed ? 'completed' : ''}">${item.text}</span>
            <div>
                <button class="toggle-btn" data-id="${item.id}">
                    <i class="fas ${item.completed ? 'fa-check-circle' : 'fa-circle'}"></i>
                </button>
                <button class="delete-btn" data-id="${item.id}">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        `;
        shoppingList.appendChild(li);
    });
}

addItemForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const text = newItemInput.value.trim();
    if (text) {
        await backend.addItem(text);
        newItemInput.value = '';
        await loadItems();
    }
});

shoppingList.addEventListener('click', async (e) => {
    if (e.target.closest('.toggle-btn')) {
        const id = parseInt(e.target.closest('.toggle-btn').dataset.id);
        await backend.toggleItem(id);
        await loadItems();
    } else if (e.target.closest('.delete-btn')) {
        const id = parseInt(e.target.closest('.delete-btn').dataset.id);
        await backend.deleteItem(id);
        await loadItems();
    }
});

loadItems();
