document.querySelectorAll('nav a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e){
        e.preventDefault();
        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});


async function loadProjects(){

const response =
await fetch(
"http://localhost:5000/projects"
);


const projects =
await response.json();


const container =
document.getElementById(
"project-container"
);


container.innerHTML="";


projects.forEach(project=>{


container.innerHTML += `

<div class="project-card">

<h3>${project.title}</h3>

<p>
${project.description}
</p>


<button onclick="editProject(${project.id})">
Edit
</button>


<button onclick="deleteProject(${project.id})">
Delete
</button>


</div>

`;

});


}



async function deleteProject(id){

await fetch(
`http://localhost:5000/projects/${id}`,
{
method:"DELETE"
}
);


loadProjects();

}




async function editProject(id){


let title =
prompt("Enter new title");


let description =
prompt("Enter new description");


await fetch(
`http://localhost:5000/projects/${id}`,
{
method:"PUT",

headers:{
"Content-Type":"application/json"
},

body:JSON.stringify({
title,
description
})

});


loadProjects();

}


loadProjects();
