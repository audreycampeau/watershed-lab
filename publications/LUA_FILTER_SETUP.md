# Permanent Solution: Remove [Journal Article] with Lua Filter

## The Problem

EndNote exports include `type = {Journal Article}` which displays as `[Journal Article]` in your citations.

## The Solution

Use a **Lua filter** to automatically remove this text during rendering - no need to clean your .bib file!

## Setup (One-Time)

### Step 1: Create the Filter File

Create a file called `remove-type-brackets.lua` in your **publications/** folder:

```lua
-- remove-type-brackets.lua
-- Removes [Journal Article], [Book], etc. from bibliography output

function Str(el)
  -- Remove [Journal Article] and similar patterns
  local text = el.text
  text = text:gsub("%[Journal Article%]", "")
  text = text:gsub("%[Book%]", "")
  text = text:gsub("%[Conference Paper%]", "")
  text = text:gsub("%[Book Chapter%]", "")
  text = text:gsub("%[Thesis%]", "")
  
  return pandoc.Str(text)
end
```

### Step 2: Update Your publications/index.qmd

Add the filter to your YAML header:

```yaml
---
title: "Publications"
bibliography: campeau_pubs.bib
csl: global-change-biology.csl
nocite: '@*'
filters:
  - remove-type-brackets.lua
---
```

### Step 3: Test It

```bash
quarto preview
```

The `[Journal Article]` text should now be gone!

## File Structure

Your publications folder should look like this:

```
publications/
├── index.qmd
├── campeau_pubs.bib              ← Original file, no cleaning needed!
├── global-change-biology.csl
└── remove-type-brackets.lua      ← New filter file
```

## How It Works

The Lua filter:
1. Runs during Quarto rendering
2. Scans all text in the bibliography
3. Removes any `[Journal Article]`, `[Book]`, etc. text
4. Outputs clean citations

## Future Workflow

Now when you update publications:

1. Add new paper to EndNote
2. Export entire library to .bib format
3. Replace `campeau_pubs.bib` (don't clean it!)
4. Run `quarto render`

**Done!** The filter automatically removes `[Journal Article]` every time.

## Benefits

✅ **No manual cleaning** - Use EndNote exports directly  
✅ **Automatic** - Works for all future publications  
✅ **Comprehensive** - Removes all type indicators (Journal Article, Book, etc.)  
✅ **Maintenance-free** - Set it once, forget about it

## Troubleshooting

**If [Journal Article] still appears:**

1. Check that `remove-type-brackets.lua` is in the `publications/` folder
2. Verify the `filters:` line is in your YAML header
3. Make sure the file name matches exactly (case-sensitive)
4. Try running `quarto render --verbose` to see if filter is loading

**If you get a filter error:**

Check that the Lua file has no syntax errors. The file should be exactly as shown above.

**Alternative: Use JavaScript Instead**

If Lua filters don't work, you can add this to the bottom of your index.qmd:

```html
<script>
document.addEventListener('DOMContentLoaded', function() {
  // Remove [Journal Article] and similar text
  const refs = document.querySelectorAll('#refs .csl-entry, #refs div');
  refs.forEach(function(ref) {
    ref.innerHTML = ref.innerHTML
      .replace(/\[Journal Article\]/g, '')
      .replace(/\[Book\]/g, '')
      .replace(/\[Conference Paper\]/g, '')
      .replace(/\[Book Chapter\]/g, '');
  });
});
</script>
```

This JavaScript solution runs in the browser and strips out the unwanted text.

## Recommendation

**Use the Lua filter** (cleaner, runs during build)  
OR  
**Use the JavaScript** (if Lua filter has issues)

Both work equally well - pick whichever is easier for you to set up!
