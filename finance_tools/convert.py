#!/usr/bin/env python3
"""Convert finance data files in the data/ folder to preferred output format."""

import csv
import glob
import os
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
DATA_DIR = SCRIPT_DIR / "data"
OUTPUT_DIR = SCRIPT_DIR / "output"

# Column mapping per file prefix: maps source columns to preferred names
PROFILE_MAP = {
    "Chase9804": {
        "column_rename": {
            "Posting Date": "Date",
            "Description": "Name",
            "Amount": "Amount",
        },
        "lead_columns": ["Date", "Name", "Amount"],
        "date_column": "Date",
        "date_format": "%m/%d/%Y",
        "date_output_format": "%Y-%m-%d",
        "sort_ascending": True,
    },
    "ally": {
        "column_rename": {
            "Date": "Date",
            "Description": "Name",
            "Amount": "Amount",
        },
        "lead_columns": ["Date", "Name", "Amount"],
        "date_column": "Date",
        "date_format": "%Y-%m-%d",
        "date_output_format": "%Y-%m-%d",
        "sort_ascending": True,
    },
}


def detect_profile(filename: str) -> str | None:
    """Return the profile key that matches the filename, or None."""
    for prefix in PROFILE_MAP:
        if filename.startswith(prefix):
            return prefix
    return None


def convert_file(filepath: Path, profile_key: str) -> Path:
    """Read a CSV, apply the profile transformations, and write to output/."""
    profile = PROFILE_MAP[profile_key]
    rename = profile["column_rename"]
    lead = profile["lead_columns"]
    date_col = profile["date_column"]
    date_fmt = profile["date_format"]
    date_out_fmt = profile.get("date_output_format")
    ascending = profile["sort_ascending"]

    with open(filepath, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        source_columns = reader.fieldnames or []
        rows = list(reader)

    # Build renamed rows
    renamed_rows = []
    for row in rows:
        new_row = {}
        for src_col in source_columns:
            dest_col = rename.get(src_col, src_col)
            new_row[dest_col] = row[src_col]
        renamed_rows.append(new_row)

    # Sort by date
    from datetime import datetime

    def parse_date(row):
        try:
            return datetime.strptime(row[date_col].strip(), date_fmt)
        except (ValueError, KeyError):
            return datetime.min

    renamed_rows.sort(key=parse_date, reverse=not ascending)

    # Reformat dates if an output format is specified
    if date_out_fmt:
        for row in renamed_rows:
            try:
                dt = datetime.strptime(row[date_col].strip(), date_fmt)
                row[date_col] = dt.strftime(date_out_fmt)
            except (ValueError, KeyError):
                pass

    # Build final column order: lead columns first, then remaining in original order
    all_dest_cols = [rename.get(c, c) for c in source_columns]
    print  ("DEBUG: all_dest_cols =", all_dest_cols)
    remaining = [c for c in all_dest_cols if c not in lead]
    output_columns = lead + remaining

    # Write output
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    out_path = OUTPUT_DIR / filepath.name
    with open(out_path, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=output_columns)
        writer.writeheader()
        writer.writerows(renamed_rows)

    return out_path


def main():
    csv_files = sorted(DATA_DIR.glob("*.CSV")) + sorted(DATA_DIR.glob("*.csv"))
    if not csv_files:
        print("No CSV files found in", DATA_DIR)
        return

    for filepath in csv_files:
        profile_key = detect_profile(filepath.name)
        if profile_key is None:
            print(f"SKIP  {filepath.name} (no matching profile)")
            continue
        out = convert_file(filepath, profile_key)
        print(f"OK    {filepath.name} -> {out.relative_to(SCRIPT_DIR)}")


if __name__ == "__main__":
    main()
