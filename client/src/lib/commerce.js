import { api } from "./api";

export async function getCart() { const { data } = await api.get("/commerce/cart"); return data; }
export async function getProductWins() { const { data } = await api.get("/commerce/product-wins"); return data; }
export async function addCartItem(entitlementId) { const { data } = await api.post("/commerce/cart/items", { entitlement_id: entitlementId }); return data; }
export async function removeCartItem(itemId) { const { data } = await api.delete(`/commerce/cart/items/${itemId}`); return data; }
export async function getSavedAddresses() { const { data } = await api.get("/commerce/addresses"); return data; }
export async function saveAddress(address) { const { data } = await api.post("/commerce/addresses", address); return data; }
export async function deleteAddress(id) { const { data } = await api.delete(`/commerce/addresses/${id}`); return data; }
export async function checkout(payload) { const { data } = await api.post("/commerce/checkout", payload); return data; }
export async function getOrders() { const { data } = await api.get("/commerce/orders"); return data; }
export async function getOrder(id) { const { data } = await api.get(`/commerce/orders/${id}`); return data; }

export async function getAdminProducts(params = {}) { const { data } = await api.get("/admin/products", { params }); return data; }
export async function getAdminProduct(id) { const { data } = await api.get(`/admin/products/${id}`); return data; }
export async function createAdminProduct(formData) { const { data } = await api.post("/admin/products", formData); return data; }
export async function updateAdminProduct(id, formData) { const { data } = await api.patch(`/admin/products/${id}`, formData); return data; }
export async function deleteAdminProduct(id) { const { data } = await api.delete(`/admin/products/${id}`); return data; }
export async function getAdminOrders() { const { data } = await api.get("/admin/orders"); return data; }
export async function updateAdminOrderStatus(id, status) { const { data } = await api.patch(`/admin/orders/${id}/status`, { status }); return data; }
