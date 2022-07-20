import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs } from 'firebase/firestore/lite';
// Follow this pattern to import other Firebase services
// import { } from 'firebase/<service>';

// TODO: Replace the following with your app's Firebase project configuration
const firebaseConfig = {
    apiKey: "AIzaSyCaxhLb-9-YHfFv6Xnwj1r0pRxCZDmq8qo",
    authDomain: "ipmanagement-music.firebaseapp.com",
    projectId: "ipmanagement-music",
    storageBucket: "ipmanagement-music.appspot.com",
    messagingSenderId: "452205548729",
    appId: "1:452205548729:web:05f7661b1a044be0053768",
    measurementId: "G-6Q9DEY39G1"
  };

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// Get a list of cities from your database
async function setCities(db) {
  const citiesCol = collection(db, 'cities');
  const citySnapshot = await getDocs(citiesCol);
  const cityList = citySnapshot.docs.map(doc => doc.data());
  return cityList;
}