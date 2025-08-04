# Scraping Youtube Data

Requirements

* YouTube API Key (generate via [Google Cloud Console](https://console.cloud.google.com/))
* Python 3.10+ installed
* Linux environment or WSL environment

### Getting Started (Backend CLI Setup)

1. #### Clone the Repository

<pre class="language-bash"><code class="lang-bash"><strong>git clone https://github.com/victorchimakanu/macrocosmos-youtube-scrapper.git
</strong>cd macrocosmos-youtube-scrapper
</code></pre>



2. #### Create and Activate a Virtual Environment

```bash
python -m venv venv 
source venv/bin/activate
```

#### 3. Install Required Packages

```bash
pip install -r requirements.txt
```

> This might take a while depending on your environment.

4\. Get a YouTube API Key

Visit [Google Cloud Console](https://console.cloud.google.com/) and follow [tutorial documentation](https://developers.google.com/youtube/v3/getting-started) to generate your API key.



5. Set Up Environment Variables

Create a `.env` file in the **root** directory and add your API key:

```
YOUTUBE_API_KEY="YOUR_API_KEY_HERE"
```



6\. Finalize Package Setup

```bash
pip install -e .
```

This validates and installs local dependencies including the `data-universe` package.



### Running the Scraper (CLI Mode)

#### 1. Navigate to the YouTube Scraper Module

```bash
cd scraping/youtube
```

#### 2. Run the Scraper

```bash
python youtube_custom_scraper.py
```



If you encounter an error like:`ModuleNotFoundError`

```bash
ModuleNotFoundError: No module named 'common.data'
```

Go back to the **root directory** and run:

```bash
PYTHONPATH="." python3.11 -m scraping.youtube.youtube_custom_scraper
```



#### 3. Choose an Option:

<figure><img src="../../../.gitbook/assets/Screenshot 2025-05-11 at 16.36.06.png" alt=""><figcaption></figcaption></figure>

You’ll be prompted to select one of the following:

1. Scrape using a default test script
2. Scrape **any video** of your choice
3. Scrape up to 5 random videos from a **specific channel**

Transcripts are returned in the terminal. For local downloads, use the **Custom API endpoints** below.



### Custom APIs – Download Transcripts via HTTP

#### &#x20;1. Start the Backend API Server

Navigate to the project root and run:

```
python backend/app.py
```



## **Available Custom Endpoints**

### Video Scrapper

<mark style="color:green;">`POST`</mark> [`http://127.0.0.1:5001/api/scrape/video`](http://127.0.0.1:5001/api/scrape/video) &#x20;

Downloads transcript to local machine

**Headers**

| Name      | Value               |
| --------- | ------------------- |
| X-API-KEY | `"youtube_api_key"` |

**Body (JSON)**

<table><thead><tr><th>Name</th><th>Details</th><th>Description</th></tr></thead><tbody><tr><td>video_id</td><td><p></p><pre><code>{
  "video_id": "UH_sOZSIk10"
}
</code></pre></td><td>video id of youtube video </td></tr></tbody></table>

**Response**

{% tabs %}
{% tab title="202" %}
```json
{
  "job_type": "video",
  "status": "started",
  "video_id": "UH_sOZSIk10"
}
```
{% endtab %}

{% tab title="400" %}
```json
{
  "error": "Invalid request"
}
```
{% endtab %}
{% endtabs %}



### Channel Scrapper

<mark style="color:green;">`POST`</mark> [`http://127.0.0.1:5001/api/scrape/channel`](http://127.0.0.1:5001/api/scrape/channel)

Scrapes random videos , allowing you specify the total number of videos you'd like to scrape

**Headers**

| Name      | Value               |
| --------- | ------------------- |
| X-API-KEY | `"youtube_api_key"` |

**Body (JSON)**

<table><thead><tr><th>Name</th><th>Details</th><th>Description</th></tr></thead><tbody><tr><td><code>channel_id</code></td><td><p></p><pre class="language-postman_json"><code class="lang-postman_json">{
  "channel_id": "UC92OMuTHmkrk0Crz5Xqi-5w",
  "max_videos": 3
}
</code></pre></td><td>Youtube Channel ID </td></tr></tbody></table>

**Response**

{% tabs %}
{% tab title="202" %}
```json
{
  "channel_id": "UC92OMuTHmkrk0Crz5Xqi-5w",
  "job_type": "channel",
  "max_videos": 3,
  "status": "started"
}
```
{% endtab %}

{% tab title="400" %}
```json
{
  "error": "Invalid request"
}
```
{% endtab %}
{% endtabs %}



These endpoints wrap the CLI scraper logic and save the output to your local `Transcripts` folder in `.txt` and `.pdf` formats.

### Testing APIs with Postman

You can test these APIs using **Postman** by:

* Setting request method to `POST`
* Using the appropriate URL
* Providing the correct JSON body
* Viewing transcript generation in your terminal and output folder

<figure><img src="../../../.gitbook/assets/Screenshot 2025-05-11 at 17.50.19.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/Screenshot 2025-05-11 at 17.51.40.png" alt=""><figcaption></figcaption></figure>

For this example, we're using custom video scrapper endpoint , when you send the request , a `Transcript` folder is generated and your desired transcript is downloaded to your local machine in PDF and .txt format!



## Frontend Interface&#x20;

Now lets interact with our custom scrapper using a sample frontend application&#x20;

1. To setup the frontend, open a split terminal and navigate into the frontend folder

```bash
cd frontend 
```



2\. Install Dependencies

```bash
npm install
```



3. Set Up Frontend Environment Variables

Create a `.env` file in the frontend directory:

```properties
VITE_API_BASE="http://127.0.0.1:5001/"
VITE_API_KEY="YOUR_YOUTUBE_API_KEY"
```



12. Launch the frontend app

```bash
npm run dev
```

Follow any of the links and it will spin up a sample application for the youtube scrapper on your local machine&#x20;

### 🧑‍💻 Using the Frontend

* Paste a **YouTube video URL or ID**
* Click **Scrape Video**
* Then click **Download Transcript**

<figure><img src="../../../.gitbook/assets/Screenshot 2025-05-11 at 15.58.44.png" alt=""><figcaption></figcaption></figure>

Transcripts are saved to the local `Transcripts` folder in **.pdf** formats. You can monitor scraper activity via the terminal.







