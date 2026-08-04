const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

// ABOUT 

let about = {
    name: "Banchiamlak Golla",
    role: "Software Engineering Student",
    description: "Passionate Software Engineering student with interests in Full-Stack Development, UI Design and solving real-world problems through software."
};

// SKILLS

let skills = [
    { id: 1, category: "Programming", skill: "C++" },
    { id: 2, category: "Programming", skill: "Java" },
    { id: 3, category: "Programming", skill: "JavaScript" },
    { id: 4, category: "Programming", skill: "Node.js" }
];

//  ABOUT

app.get("/about", (req, res) => {
    res.json(about);
});

app.put("/about", (req, res) => {
    about = req.body;
    res.json(about);
});

//SKILLS 

app.get("/skills", (req, res) => {
    res.json(skills);
});

app.post("/skills", (req, res) => {

    const newSkill = {
        id: Date.now(),
        category: req.body.category,
        skill: req.body.skill
    };

    skills.push(newSkill);

    res.json(newSkill);

});

app.put("/skills/:id", (req, res) => {

    const id = Number(req.params.id);

    const skill = skills.find(s => s.id === id);

    if (!skill) {
        return res.status(404).json({
            message: "Skill not found"
        });
    }

    skill.category = req.body.category;
    skill.skill = req.body.skill;

    res.json(skill);

});

app.delete("/skills/:id", (req, res) => {

    const id = Number(req.params.id);

    skills = skills.filter(s => s.id !== id);

    res.json({
        message: "Skill deleted"
    });

});
// PROJECTS 

let projects = [
    {
        id: 1,
        title: "Internship & Job Portal",
        description: "C++ and MySQL system."
    },
    {
        id: 2,
        title: "Quiz Game",
        description: "Java desktop application."
    }
];

app.get("/projects", (req, res) => {
    res.json(projects);
});

app.post("/projects", (req, res) => {

    const newProject = {
        id: Date.now(),
        title: req.body.title,
        description: req.body.description
    };

    projects.push(newProject);

    res.json(newProject);

});

app.put("/projects/:id", (req, res) => {

    const id = Number(req.params.id);

    const project = projects.find(p => p.id === id);

    if (!project) {
        return res.status(404).json({
            message: "Project not found"
        });
    }

    project.title = req.body.title;
    project.description = req.body.description;

    res.json(project);

});

app.delete("/projects/:id", (req, res) => {

    const id = Number(req.params.id);

    projects = projects.filter(p => p.id !== id);

    res.json({
        message: "Project deleted"
    });

});

// EXPERIENCE 

let experiences = [
    { id: 1, title: "Frontend Development" },
    { id: 2, title: "GitHub Collaboration" },
    { id: 3, title: "Database Organization" }
];

app.get("/experience", (req, res) => {
    res.json(experiences);
});

app.post("/experience", (req, res) => {

    const newExperience = {

        id: Date.now(),

        title: req.body.title

    };

    experiences.push(newExperience);

    res.json(newExperience);

});

app.put("/experience/:id", (req, res) => {

    const id = Number(req.params.id);

    const experience = experiences.find(e => e.id === id);

    if (!experience) {
        return res.status(404).json({
            message: "Experience not found"
        });
    }

    experience.title = req.body.title;

    res.json(experience);

});

app.delete("/experience/:id", (req, res) => {

    const id = Number(req.params.id);

    experiences = experiences.filter(e => e.id !== id);

    res.json({
        message: "Experience deleted"
    });

});


app.listen(5000, () => {
    console.log("Server running on port 5000");
});