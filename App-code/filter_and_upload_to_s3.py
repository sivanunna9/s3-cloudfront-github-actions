import os
import json
import requests
import boto3

def filter_products(url, output_file):
    """
    Download JSON from URL, filter products with price >= 100,
    and save filtered data to a JSON file.
    """
    response = requests.get(url)
    if response.status_code != 200:
        raise Exception(f"Failed to fetch data: {response.status_code}")

    data = response.json()
    filtered = [p for p in data.get("products", []) if p["price"] >= 100]

    with open(output_file, "w") as f:
        json.dump({"products": filtered}, f, indent=4)

    print(f" Filtered data saved to {output_file}")

def upload_to_s3(file_path, s3_bucket, s3_key):
    """
    Upload a JSON file to S3 with Content-Disposition metadata.
    Uses AWS credentials from environment variables.
    """
    aws_access_key = os.getenv("AWS_ACCESS_KEY_ID")
    aws_secret_key = os.getenv("AWS_SECRET_ACCESS_KEY")
    aws_region = os.getenv("AWS_DEFAULT_REGION")

    if not all([aws_access_key, aws_secret_key, aws_region, s3_bucket]):
        raise EnvironmentError(" Missing AWS credentials or bucket name!")

    s3 = boto3.client(
        "s3",
        aws_access_key_id=aws_access_key,
        aws_secret_access_key=aws_secret_key,
        region_name=aws_region
    )

    s3.upload_file(
        Filename=file_path,
        Bucket=s3_bucket,
        Key=s3_key,
        ExtraArgs={
            "ContentType": "application/json",
            "ContentDisposition": f'attachment; filename="{os.path.basename(file_path)}"'
        }
    )
    print(f" File uploaded successfully to s3://{s3_bucket}/{s3_key}")

def verify_via_cloudfront(url):
    print(f"Verifying file from CloudFront URL: {url}")
    response = requests.get(url)
    if response.status_code == 200:
        try:
            data = response.json()
            print(" JSON verified successfully from CloudFront.")
            print(f"Total filtered products: {len(data.get('products', []))}")
        except json.JSONDecodeError:
            print(" The file downloaded is NOT a valid JSON.")
    else:
        print(f" Failed to download file. Status code: {response.status_code}")


if __name__ == "__main__":
    url = "https://dummyjson.com/products"
    output_file = "filtered_products.json"
    s3_key = "filtered_products.json" 
    s3_bucket = "kishore-demo-cf" ## Add your s3 bucket name
    cloudfront_url= "https://d24zjf9hlg3b46.cloudfront.net/" ## Add your cloudfront url
    
    

    filter_products(url, output_file)
    upload_to_s3(output_file, s3_bucket, s3_key)
    verify_via_cloudfront(cloudfront_url)
