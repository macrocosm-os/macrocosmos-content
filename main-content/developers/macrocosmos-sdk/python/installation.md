# Installation

### Prerequisites&#x20;

* Python 3.9+

### Install the Macrocosmos SDK using Pip

```bash
pip install macrocosmos-sdk
```



### Client

The **Client** classes — like `ApexClient` and `GravityClient` , serve as the **primary interface** between your application and a specific Macrocosmos subnet.

```python
client = mc.ApexClient(api_key="")
```

When you initialize a client like `ApexClient` or `GravityClient`, you're creating a scoped connection to that subnet. This setup manages authentication via your API key.



### Usage

Once you have created a `Client` instance, you can call API methods as shown in the examples below.
