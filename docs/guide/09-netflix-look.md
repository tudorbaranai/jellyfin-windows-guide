# Part 9: The Netflix look

Optional. A Netflix-style theme, a rotating banner of films at the top, and home rows like "Because you watched".

## 9.1 Check before you install

A theme only changes how pages look. A plugin is code that runs inside your server. Before installing anything third-party:

| Check | Good sign |
|---|---|
| Listed in [awesome-jellyfin](https://github.com/awesome-jellyfin/awesome-jellyfin)? | Yes |
| Stars, contributors, recent releases | Hundreds of stars, several people, active |
| A build for your Jellyfin version | Yes |
| A theme's files | Only `.css` and images |

## 9.2 The theme

**What:** [Netflin](https://github.com/ahza-code/Netflin): black and red, title art, rows of cards. Pure CSS.

**How:** Dashboard > General > **Custom CSS code**, paste, Save:

```css
@import url("https://cdn.jsdelivr.net/gh/ahza-code/Netflin@a62266ebd51191bb5cc8e519faaa2b96dcf4f61f/Theme/Netflin.min.css");
```

The long code pins one version (v1.2.5), so the look never changes unless you change it. For a newer version: Netflin's Releases page > the tag > its commit code.

Then on every device: profile picture > Settings > Display > **Display mode: Auto** > Save.

To remove it: delete the line and Save.

**Check:** after Ctrl + F5, pages are black with red accents.

Prefer something calmer? [ElegantFin](https://github.com/lscambo13/ElegantFin) is the other popular theme. One theme at a time.

## 9.3 The plugins

**What:** four plugins by IAmParadox27:

| Plugin | Does |
|---|---|
| File Transformation | Lets the others change Jellyfin's pages. Needed |
| Plugin Pages | Settings pages for users. Needed |
| Media Bar | The rotating banner |
| Home Screen Sections | The home rows |

**How:**

1. Dashboard > Plugins > **Repositories** > **+**: name `IAmParadox27`, URL `https://www.iamparadox.dev/jellyfin/plugins/manifest.json`. Save.
2. Catalog > install all four. For Home Screen Sections, pick the one **without** "(Experimental)".
3. Dashboard > **Restart**. Plugins do nothing until then.

**Check:** Dashboard > Plugins shows all four as **Active**.

## 9.4 Pick the home rows

**How:**

1. Dashboard > Plugins > Home Screen Sections: tick **Enabled by Default**, tick the rows anyone may use, Save.
2. Each user: profile picture > Settings > **Modular Home** > tick their rows > Save.
3. Restart Jellyfin, then Ctrl + F5. The rows are cached for 24 hours otherwise.

**Check:** the home page shows the banner and the chosen rows.

## 9.5 Updates

The plugins update themselves. They're built for one exact Jellyfin version, so before updating Jellyfin, check the catalog has builds for the new one ([part 10](10-everyday-use.md#update-jellyfin)).

Next: [Part 10: Everyday use](10-everyday-use.md)
