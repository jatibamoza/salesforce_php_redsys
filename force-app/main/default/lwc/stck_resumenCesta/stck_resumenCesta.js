import { LightningElement, api, track } from 'lwc';

export default class Stck_resumenCesta extends LightningElement {
    @track _cartItems = [];

    @api 
    get cartItems() {
        return this._cartItems;
    }
    set cartItems(data = []) {
        this._cartItems = data.map(item => ({
            ...item,
            totalPrice: item.price * item.quantity
        }));
    }

    get hasItems() {
        return this._cartItems && this._cartItems.length > 0;
    }

    get totalAmount() {
        if (!this.hasItems) return 0;
        return this._cartItems.reduce((total, item) => total + item.totalPrice, 0);
    }

    handleQuantityChange(event) {
        const itemId = event.target.dataset.id;
        const newQuantity = parseInt(event.target.value, 10);
        
        if (newQuantity > 0) {
            const updatedItems = this._cartItems.map(item => {
                if (item.id === itemId) {
                    return { ...item, quantity: newQuantity };
                }
                return item;
            });
            this.dispatchUpdate(updatedItems);
        }
    }

    handleRemoveItem(event) {
        const itemId = event.target.dataset.id;
        const updatedItems = this._cartItems.filter(item => item.id !== itemId);
        this.dispatchUpdate(updatedItems);
    }
    
    dispatchUpdate(items) {
        this.dispatchEvent(new CustomEvent('updatecart', {
            detail: { items: items }
        }));
    }
}