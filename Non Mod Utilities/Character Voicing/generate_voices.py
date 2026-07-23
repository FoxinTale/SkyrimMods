# C:\TTS\kokoro_from_csv.py

import csv
import os
import numpy as np
import soundfile as sf
import torch
from kokoro import KPipeline, KModel

# === CONFIG ===


CSV_FILE = r"C:\TTS\Aileen.csv"
OUT_DIR = r"C:\TTS\aileen_out_24k"

TEXT_COLUMN = "text"
OUT_COLUMN = "out_path"

VOICE = "af_heart"
LANG_CODE = "a"
SPEED = 0.98

# === SCRIPT ===

def clean_out_path(value: str) -> str:
    value = value.strip().strip('"').strip()

    # If the CSV has accidental spaces/tabs after the filename
    value = value.replace("\t", "")

    # Keep only the filename, not any folders accidentally included
    value = os.path.basename(value)

    if not value.lower().endswith(".wav"):
        value += ".wav"

    return value


def main():
    os.makedirs(OUT_DIR, exist_ok=True)

    DEVICE = "cuda" if torch.cuda.is_available() else "cpu"
    print("Using device:", DEVICE)

    model = KModel().to(DEVICE).eval()
    pipeline = KPipeline(lang_code=LANG_CODE, model=model)

    with open(CSV_FILE, "r", encoding="utf-8-sig", newline="") as f:
        reader = csv.DictReader(f)

        print("Detected columns:", reader.fieldnames)

        if TEXT_COLUMN not in reader.fieldnames:
            raise RuntimeError(f"Missing column: {TEXT_COLUMN}")

        if OUT_COLUMN not in reader.fieldnames:
            raise RuntimeError(f"Missing column: {OUT_COLUMN}")

        for row_number, row in enumerate(reader, start=2):
            text = row.get(TEXT_COLUMN, "").strip()
            out_name = clean_out_path(row.get(OUT_COLUMN, ""))

            if not text:
                print(f"Skipping row {row_number}: empty text")
                continue

            if not out_name:
                print(f"Skipping row {row_number}: empty out_path")
                continue

            out_file = os.path.join(OUT_DIR, out_name)

            print()
            print(f"Row {row_number}")
            print(f"Text: {text}")
            print(f"Output: {out_file}")

            chunks = []
            generator = pipeline(text, voice=VOICE, speed=SPEED)

            for graphemes, phonemes, audio in generator:
                print("Phonemes:", phonemes)
                chunks.append(audio)

            if not chunks:
                print(f"No audio generated for row {row_number}")
                continue

            audio_all = np.concatenate(chunks)
            sf.write(out_file, audio_all, 24000)
            print("Wrote:", out_file)


if __name__ == "__main__":
    main()