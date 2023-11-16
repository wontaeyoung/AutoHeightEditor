[![Platform](https://img.shields.io/badge/Platform-iOS_iPadOS-orange.svg)](https://developer.apple.com/ios/)
[![Deployments](https://img.shields.io/badge/Deployments-14.0+-skyblue.svg)](https://developer.apple.com/documentation/ios-ipados-release-notes/ios-ipados-14-release-notes)
[![UseFor](https://img.shields.io/badge/UseFor-SwiftUI-blue.svg)](https://developer.apple.com/xcode/swiftui/)
[![SPM](https://img.shields.io/badge/SPM-Compatible-khaki.svg)](https://github.com/apple/swift-package-manager)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/wontaeyoung/AutoHeightEditor/blob/main/LICENSE)
[![Github](https://img.shields.io/badge/Author-wontaeyoung-red.svg)](https://www.github.com/wontaeyoung)

**`AutoHeightEditor`** is a custom **`TextEditor`** library with Dynamic Height functionality.

<br>

# **Background**

I created this custom **`TextEditor`** because it was a requirement for a project I was working on.

In the project, an input interface that dynamically adjusts in height was needed. From iOS 16, an input interface that works as Dynamic Height can be easily used through the **`axis`** parameter of **`TextField`**.

However, the minimum supported version of the project was decided to be iOS 15.0+, and for multiple lines of text input, **`TextEditor`** had to be used.

As those who have used the standard API **`TextEditor`** might agree, it lacks some features compared to **`TextField`**, especially it takes up the maximum possible height unless a specific height is designated.

To solve this, I created the **`AutoHeightEditor`**, which dynamically calculates the appropriate height.

You can check out the detailed background and implementation process on [my blog](https://velog.io/@wontaeyoung/swiftui4).

<br><br>

# **Library Introduction**

The main feature of **`AutoHeightEditor`** is essentially Dynamic Height.

It changes the height of the TextEditor in real-time based on font height, line spacing, text length, and new line characters.

<br>

## **Main Logic**

1. Count the number of **`\n`** (new line characters) in the text.
2. Calculate the width of the **`TextEditor`** and the length of the entered text to determine how many times automatic line breaks should occur.
3. Combine the counts from steps 1 and 2 to calculate the total number of line breaks.
4. Calculate the total height of the **`TextEditor`** by considering the font size, line spacing, and number of line breaks.

<br>

## **User Convenience**

The height changes from a minimum of 1 line to a maximum of **`maxLine`** based on user input. Options like maximum line numbers, used font, line spacing, and activation status are taken as parameters.

As I customized a component for personal use to fit into a library, I considered the environment of other users and added the following features:

- Accepts **`isEnabled`** binding for external control of activation status.
- Option to choose the use of a fixed Border stroke.
- Customizable disabled placeholder text.
- Reflects the result of regular expression matching in a bound Bool variable.

<br>

As mentioned in the production background, **iOS 16** is still a version that is burdensome to apply in practice. Therefore, it was implemented to be usable from **iOS 14**, where **`TextEditor`** first appeared.

<br><br>

# **Parameter List**

```swift

public init (
    text: Binding<String>,
    font: Font = .body,
    lineSpace: CGFloat = 2,
    maxLine: Int,
    hasBorder: Bool,
    isEnabled: Binding<Bool>,
    disabledPlaceholder: String,
    regExpUse: RegExpUse
)
```

<br><br>

```swift
text: Binding<String>
```

The text string bound to the editor. It is used by injecting a binding from the outside.

<br><br>

```swift
font: Font
```

The font type applied to the text. **`body`** is injected as the Default Value, and if you have a different desired font, you can inject and use it.

<br><br>

```swift
lineSpace: CGFloat
```

The line spacing between text lines. **`2`** is injected as the Default Value, and if you have a different desired value, you can inject and use it.

<br><br>

```swift
maxLine: Int
```

The maximum number of lines for which the editor's height increases. As the input lines increase, the height of the editor grows up to **`maxLine`**, and then does not increase further.

<br><br>

```swift
hasBorder: Bool
```

Determines whether to use the default provided **`Stroke`**. The basic **`Stroke`** comes with a Gray color and a CornerRadius of 20.

<br><br>

```swift
isEnabled: Binding<Bool>
```

Determines whether the editor is active. It is injected and used from the outside via binding.

<br><br>

```swift
disabledPlaceholder: String
```

A message to guide the user when the editor is disabled.

<br><br>

```swift
public enum RegExpUse {
    case use(pattern: String, isMatched: Binding<Bool>)
    case none
}

regExpUse: RegExpUse
```

The type that determines whether to use regular expression matching.

If not used, pass **`none`**; if used, pass **`use`**.

**`pattern`** is the regular expression pattern to compare with the text, and **`isMatched`** is a binding variable to be injected and used from the outside.

The text is checked against the regular expression whenever it is updated, and the bound variable **`isMatched`** is automatically updated.

<br><br>

# **Usage Guide**

Let's start by initializing **`AutoHeightEditor`** to check its basic functionality.

Initially, it starts with a height of 1 line, and the height dynamically increases up to a maximum of 5 lines depending on the entered text.

It detects not only line breaks caused by **`\n`** (new line characters) but also moments when the text becomes long enough to cause automatic line breaks, and reflects this in the height.

```swift
AutoHeightEditor(
    text: $text,
    maxLine: 5,
    hasBorder: true,
    isEnabled: $isEnabled,
    disabledPlaceholder: "This editor has been disabled",
    regExpUse: .none)
```

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/4208a9ae-74aa-4819-a42d-f04a5065e282">

<br><br>

### **Modifying the Maximum Line Count**

You can determine the maximum line height by adjusting **`maxLine`**.

In the example below, we'll pass **`7`** to allow it to expand up to a height of 7 lines.

```swift
AutoHeightEditor(
    text: $text,
    maxLine: 7,
    hasBorder: true,
    isEnabled: $isEnabled,
    disabledPlaceholder: "This editor has been disabled",
    regExpUse: .none)
```

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/71432a5c-0dbc-400e-b022-ec4ddf428a8d">

<br><br>

### **Modifying Font and Line Spacing**

> In the current version, values not in SwiftUI's basic Font type are not available. This is because we do a 1:1 mapping with UIFont internally to get the font size.

**`font`** and **`lineSpace`** come with the Default Values of **`body`** and **`2`**, respectively.

If you have desired values other than these Default Values, you can inject new ones.

In the example below, we'll pass **`title2`** and **`10`** to increase the font size and line spacing.

```swift
AutoHeightEditor(
    text: $text,
    font: .title2,
    lineSpace: 10,
    maxLine: 5,
    hasBorder: true,
    isEnabled: $isEnabled,
    disabledPlaceholder: "This editor has been disabled",
    regExpUse: .none)
```

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/dca01cbe-3065-4729-a0c8-3628398c2761">

<br><br>

### **Customizing the Border Stroke**

You can decide whether to use the provided default border stroke with **`hasBorder`**.

The basic **`Stroke`** is Gray in color with a CornerRadius of 20.

In the example below, we'll set **`hasBorder`** to false to remove the border.

```swift
AutoHeightEditor(
    text: $text,
    maxLine: 5,
    hasBorder: false,
    isEnabled: $isEnabled,
    disabledPlaceholder: "This editor has been disabled",
    regExpUse: .none)
```

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/d18d2610-7a94-4270-a16e-2b311f8b7c57">

<br><br>

You can use **`overlay`** from outside to write a custom design.

In the example below, we'll delete the default border and draw a rectangular style border with overlay.

```swift
AutoHeightEditor(
    text: $text,
    maxLine: 5,
    hasBorder: false,
    isEnabled: $isEnabled,
    disabledPlaceholder: "This editor has been disabled",
    regExpUse: .none)
.overlay {
    Rectangle()
        .stroke()
}
```

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/33dbfba0-1719-48c3-b23e-a093a4919aef">

<br><br>

### **Managing Editor Activation**

**`isEnabled`** controls whether the editor receives touch events.

It is injected and used from the outside via binding.

When disabled, the text passed to **`disabledPlaceholder`** is displayed as a placeholder.

In the example below, we'll bind a variable to isEnabled and manage it with a Toggle from the outside.

```swift
AutoHeightEditor(
    text: $text,
    maxLine: 5,
    hasBorder: true,
    isEnabled: $isEnabled,
    disabledPlaceholder: "This editor has been disabled",
    regExpUse: .none)
```

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/16185584-78db-4804-8134-f409e596f1d9">

<br><br>

If there is no separate case for disabling, you can pass **`.constant()`** and an empty string for **`disabledPlaceholder`**.

```swift
AutoHeightEditor(
    text: $text,
    maxLine: 5,
    hasBorder: true,
    isEnabled: .constant(true),
    disabledPlaceholder: "",
    regExpUse: .none)
```

<br><br>

### **Using Regular Expressions**

**`regExpUse`** enum determines whether to use regular expression matching.

If not used, pass **`none`**; if used, pass **`use`**.

**`use`** allows you to pass associated values **`pattern`** and **`isMatched`**.

**`pattern`** is the regular expression pattern string to be compared with the text.

**`isMatched`** is a binding variable injected and used from the outside.

In the example below, we'll pass an email pattern.

```swift
AutoHeightEditor(
    text: $text,
    maxLine: 5,
    hasBorder: true,
    isEnabled: $isEnabled,
    disabledPlaceholder: "This editor has been disabled",
    regExpUse: .use(
        pattern: #"^[a-zA-Z0-9+-\_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]{2,3}+$"#,
        isMatched: $isMatched))
```

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/4e70d296-e5ca-464c-962e-0d09f01a8409">

<br><br>

### **Focus Management**

I chose not to include **`@FocusState`** within the package to keep the minimum supported version at **iOS 14** rather than raising it to **iOS 15**.

After considering the trade-offs, I thought it more beneficial to lower the version support than to enhance usability by passing parameters.

Users with project support versions of 15.0+ can manage focus externally using **`FocusState`**.

```swift
AutoHeightEditor(
    text: $text,
    maxLine: 5,
    hasBorder: true,
    isEnabled: $isEnabled,
    disabledPlaceholder: "This editor has been disabled",
    regExpUse: .none)
.focused($isFocus)
```

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/57bb4b94-5e73-4e69-ba99-a620b04b741c">

<br><br>

### **Dark Mode Support**

The current version only supports basic dark mode adaptation by passing **`primary`** to the internal **`foregroundColor`**.

The default provided **`Stroke`** color remains fixed at **`gray`** for both light and dark modes.

<img width="300" src="https://github.com/wontaeyoung/AutoHeightEditor/assets/45925685/db6dff3d-ef0e-4929-864d-418c01b164a1">

<br><br>

# **License**

**`AutoHeightEditor`** is available under the MIT license.

Please see the [License](https://github.com/wontaeyoung/AutoHeightEditor/blob/main/LICENSE) for more information.
