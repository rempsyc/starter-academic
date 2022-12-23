
# Welcome to my academic website, [remi-theriault.com](https://remi-theriault.com)

This site was built using (and adapting) the Academic Template for [Hugo](https://github.com/gohugoio/hugo). The Hugo **Academic Resumé Template** empowers you to create your job-winning online resumé and showcase your academic publications. [**Wowchemy**](https://wowchemy.com) makes it easy to create a beautiful website for free. Edit your site in Markdown, Jupyter, or RStudio (via Blogdown), generate it with Hugo, and deploy with GitHub or Netlify. Customize anything on your site with widgets, themes, and language packs.

# So, you want to fork my site? Go ahead! But read this...

I encourage everyone and anyone to fork (copy) my site if it looks like you would want your own site. Of course, I would request to keep the site footer to acknowledge Wowchemy as the open source website builder, and well, myself as the creator of that adaptation of the template!

Below, you will find detailed instructions about what to do after forking the site.

# Instructions for forking this site

## Installing the prerequisites...

1. First, you will need to [create a fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) of this repository. To create a fork, simply click on the fork button at the complete top right of the page. You will be asked to confirm and you can simply go with the default options and name.

1. Second, you will need to create an account at https://www.netlify.com/, click `Add a new site`, `Import an existing project`, then choose `GitHub` as provider, then pick the fork you created before. You'll see a few more screen where you can just go with the default options each time (select all repositories, etc.).

1. There! You have your website up and running already! The URL to your new site will look something like this `yoursitename.netlify.app`. You can change the name of the subdomain (`yoursitename`, before the `.netlify`) from the Netlify site settings, but if you have your own custom domain name, you [can also change it](https://www.netlify.com/blog/2021/12/20/how-to-add-custom-domains-to-netlify-sites/). Try your new site URL in your browser to confirm it works.

1. Now it's time to make some changes, like changing the name, bio, photo, publications, etc. Exciting!! Note that it is possible to make all changes directly on github.com, but I believe it is easier to see the changes you bring to the website in real-time. Therefore, I recommend that you download [GitHub Desktop](https://desktop.github.com/), log in, and make a local copy of (i.e., "clone") the fork on your computer. You will be asked "how are you planning to use this fork?"" Choose "For my own purposes".

1. Next, to view the website in real time, you will need to use Windows PowerShell. It is already installed with Windows, you just have to type the name in the search bar and it will pop up.

1. You will also need to install Hugo extended. [Detailed instructions](https://wowchemy.com/docs/getting-started/install-hugo-extended/#cms) are available, but essentially:

> Open the Windows Powershell 5 app, installing it if necessary.
>
> Install Scoop, the package manager for Windows, by pasting the following commands into Powershell and pressing the Enter ↵ key:

```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
iwr -useb get.scoop.sh | iex
```

> Press Y and enter if asked Do you want to change the execution policy?.
>
> Install Hugo and its dependencies:

```
scoop install git go hugo-extended nodejs
```

## Running the live server

So far, so good. Next, in Windows PowerShell, there are two commands you need to kickstart your live website preview. First, you have to change the working directory to where you cloend your fork. This might look like this:

```
cd "D:\github\starter-academic"
```

Second, you have to run the following code to run the hugo server that will preview your site:

```
hugo server
```

Then, open your browser to the following URL to browse your site:

```
http://localhost:1313/
```

## Personalizing your site

Nice! Now is time to have fun. Make sure to change the following:

1. **The site title and menu layout.**

    1. For the site title, edit the following file: `config\_default\config.toml`.
    1. For the menu layout, edit the following file: `config\_default\menus.toml`.

1. **The website icon (you will see that when seeing your site in Google search results for example)**

    1. For this, change the photo located at `assets\media\icon.png`.

1. **On the home page: your name and catchy intro sentence.**
    
    1. For this, edit the following file: `content\en\home\blank.md` (beware, that part was made in custom HTML so could be confusing! However, you don't need to worry about that part if you only change the name and personalized sentence).

1. **On the bio page: Your photo, name, title, university, social media URLs, bio, interests, education, and skills.**

    1. For this, change the name of the following folder to your name: `content\en\authors\remi-theriault`.

    1. Next, within that folder, change the photo called `avatar.jpg` and edit the file called `_index.md`.

    1. Next, change the name of the specified author in the following file: `content\en\bio\bio.md`.)
    
    1. Next, to change your skills, edit the following file: `content\en\bio\skills.md`.

1. **On the contact page: your email, phone number, address, google maps coordinates, and directions.**

    1. For this, edit the following file: `config\_default\params.toml`.
    
    1. To remove the picture of the building, first delete the `![SU](SU.jpg)` line in the `content\en\contact\contact.md` file. Next, you can delete the other pictures within that folder to clean things up (unless you want to use your own photo of course).

1. **On the publications page: your publications (duh!)**

    1. For this, edit the individual publication folders in the following folder: `content\en\publication`. You'll have to edit each publication's `index.md` file individually.

1. **You can delete some sections of the website if they don't apply to you: News, Blog, Media, Tutorials, Donate, etc.**

    1. Those sections are located in `content\en`.

1. **Note that there is still things that you don't see on the site but might want to clean anyway (more below).**

Some tips:

- To change the French (or other language) version of the site, you will need to repeat those steps in the `content\fr` subfolder.
- Normally, for folders located in the `content` folder, there is a `index.md` file. That's the file you don't usually want to change. Edit the other file instead. But for project pages (blog, media, news, tutorials), it works a bit differently. The page has its own folders, but individual elements have their own folder too, usually called "project-media" or something like that, and in those cases, you want to edit the `index.md` file.
- To host files at the root of your site, place them in the `static` folder. Feel free to delete all of my other files there (EXCEPT the admin folder, which is needed for administrative reasons). You can ignore all other files that we haven't covered so far.
- Redirects can be specified in the root file `netlify.toml`. In that file, please delete the "Strict-Transport-Security" headers paragraph (unless you have your own Report URI account).
- Google analytics can be specified in `config\_default\params.toml` (please delete/replace my GA ID).
- Don't hesitate to ask me questions, or ask on the wonderful Wowchemy discord: https://discord.gg/z8wNYzb
- Make sure to read the docs first though: https://wowchemy.com/docs/

# Saying thank you

If you forked my site and enjoy it, consider [sponsoring me](https://github.com/sponsors/rempsyc) and [Geo Cushen](https://github.com/sponsors/gcushen), the creator of Wowchemy.

