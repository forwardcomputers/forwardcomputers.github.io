# hass-fwc-icons

Custom icon pack designed for Home Assistant.

## Install

### HACS

Add this repo via HACS as a plugin and install. See the [HACS install guide](./HACS_INSTALL.md) for step by step instructions.

### Manual

Copy the `hass-fwc-icons.js` file into `<config>/www/` where `<config>` is your home-assistant config directory (the directory where your `configuration.yaml` resides).

Add the folowing to the `frontend` section of your `configuration.yaml`

```yaml
frontend:
  extra_module_url:
    - /local/hass-fwc-icons.js
```

Or add the following to your lovelace configuration using the Raw Config editor under Configure UI or ui-lovelace.yaml if using YAML mode.

```yaml
resources:
  - type: js
    url: /local/hass-fwc-icons.js
```

Restart home-assistant.

## Using

The icons uses the prefix `fwc:`.

## Thanks

Thanks to @thomasloven, as I used his hass-fontawesome as a template for this pack
