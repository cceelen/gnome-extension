// The models whose product name the keys extension acts on. No GNOME imports:
// the tests run it with node.

const MODELS = ['UX8406', 'UX8407'];

/** Whether a DMI product name is that of a model in MODELS. */
export function isSupportedModel(productName) {
    return MODELS.some((model) => productName.includes(model));
}
