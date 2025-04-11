# Installation

### Prerequisites&#x20;

* Python 3.9+
* Typescript

### Install the Macrocosmos SDK using Pip or npm

{% tabs %}
{% tab title="Typescript" %}
```javascript
npm install macrocosmos
```
{% endtab %}

{% tab title="Python" %}
```python
pip install macrocosmos
```
{% endtab %}
{% endtabs %}

### Client

The **Client** classes — like `ApexClient` and `GravityClient` , serve as the **primary interface** between your application and a specific Macrocosmos subnet.

{% tabs %}
{% tab title="JavaScript" %}
```javascript
// Initialize the client
const client = new ApexClient({ apiKey: 'your-api-key' });
```
{% endtab %}

{% tab title="Python" %}
<pre class="language-python"><code class="lang-python">// Initialize the client
<strong>client = mc.ApexClient(api_key="")
</strong></code></pre>
{% endtab %}
{% endtabs %}

When you initialize a client like `ApexClient` or `GravityClient`, you're creating a scoped connection to that subnet. This setup manages authentication via your API key.



### Usage

Once you have created a `Client` instance, you can call API methods as shown in the examples below.
