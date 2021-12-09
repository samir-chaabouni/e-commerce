const express = require('express');
const app = express();
const PORT = 3002;
app.use(express.json());
app.use(express.static(__dirname + "/res"));

const users = [
    { id : 1, username : "giratin", password: "giratin" },
    { id : 2, username : "tryvl", password: "tryvl" }
]

const foods= [
    { id : "1", title : "Carète Moulu", prix: "6.2", image: "product1.jpg", description: "Carète Moulu" },
    { id : "2", title : "Melange Grillades", prix: "9.5", image: "product2.jpg", description: "Melange Grillades" },
    { id : "3", title : "Ras El Hanout Moulu", prix: "7.8", image: "product3.jpg", description: "Ras El Hanout Moulu" },
]

app.post('/api/login', async(req,res)=>{
    const { username, password } = req.body;

    if(!username || !password){
        return res.status(400).json({ error : "Missing credentials" });
    }

    const result = users.find((user)=> user.username == username && user.password == password );
    if(result){
        return res.status(200).json( result );
    }

    res.status(401).json({ error : "Username/Password are incorrect" });
});

app.get('/api/sandwish',async(req,res)=>{
    res.status(200).json(foods)
});

app.get('/api/sandwish/:id',async(req,res)=>{
    const { id } = req.params;
    if(id <=0 || id >8 ){
        res.status(404).json({ error : "Sandwish not found" })
    }
    res.status(200).json(foods[id -1]);
});

app.listen(PORT,"0.0.0.0", ()=>{
    console.log(`app is running on port ${PORT}`);
});