importScripts("https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js");

const params = new URL(self.location.href).searchParams;
const firebaseConfig = {
  apiKey: params.get("apiKey"),
  authDomain: params.get("authDomain"),
  projectId: params.get("projectId"),
  messagingSenderId: params.get("messagingSenderId"),
  appId: params.get("appId"),
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  if (payload.notification) return;

  const notification = payload.notification || {};
  const data = payload.data || {};

  self.registration.showNotification(notification.title || "CopUpBid notice", {
    body: notification.body || "You have a new CopUpBid update.",
    icon: "/copupcoin.png",
    badge: "/copupcoin.png",
    data: {
      url: data.path || "/dashboard",
      ...data,
    },
  });
});

self.addEventListener("notificationclick", (event) => {
  event.notification.close();

  const url = event.notification.data?.url || "/dashboard";
  const targetUrl = new URL(url, self.location.origin).href;

  event.waitUntil(
    clients
      .matchAll({ type: "window", includeUncontrolled: true })
      .then((clientList) => {
        const existingClient = clientList.find((client) => client.url === targetUrl);
        if (existingClient) return existingClient.focus();
        return clients.openWindow(targetUrl);
      })
  );
});
