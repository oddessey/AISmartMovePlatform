
from fastapi import FastAPI
from app.routers import vision, chatbot, matching
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="SmartMove AI Server", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(vision.router, prefix="/api/v1/vision", tags=["Vision"])
app.include_router(chatbot.router, prefix="/api/v1/chatbot", tags=["Chatbot"])
app.include_router(matching.router, prefix="/api/v1/matching", tags=["Matching"])

@app.get("/")
def root():
    return {"message": "SmartMove AI Server is running 🤖", "docs": "/docs"}
