const express= require("express");

const app = express();
const PORT = 3000;

const student =[
    {
        id:1,
        name:"Abebe",
        age:21
    },
    {
        id:2,
        name:"Kebede",
        age:22
    },
    {
        id:3,
        name:"Hana",
        agw:20
    }
];

app.get("/",(req,res)=>{
    res.send("Hello Students!");
});

app.get("/about",(req,res)=>{
    res.send("Welcome to Backend Engineering");
});

app.get("/student", (req,res)=>{
    res.json({
        id:1,
        name:"Abebe",
        age:21,
        department:"computer science"
    });
});
app.get("/students", )

app.listen(PORT, ()=>{

    console.log(`server is running on http://localhost${PORT}`);
});
