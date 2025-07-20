# Transfer money to internal and brokerage accounts

## Introduction


[](youtube:qHVYXagpAC0?start=1089)

*Watch the tutorial video above*

This lab showcases conversational interaction with financial data using Oracle Database's Natural Language to SQL capabilities (Select AI), vector search, and speech AI services. The application demonstrates a complete voice-to-voice financial data query system that transforms spoken questions into database insights.

The workflow begins when you ask a financial question using natural language. The system leverages Oracle's speech AI service (or multicloud alternatives like Google's speech AI) to convert your spoken query into text. This text is then processed by Oracle Database's Select AI feature, which automatically translates natural language into both regular SQL queries and vector searches against your private database.

The system performs comprehensive searches across your financial data, including all the transaction history, stock purchases, real estate investments, and other financial activities you've generated throughout the various application modules. The database executes the appropriate queries and vector searches to gather relevant information, then generates a text-based answer that addresses your specific question.

To complete the conversational experience, the text response is converted back into speech using AI speech synthesis and played back to you audibly. For enhanced user experience, the system can optionally include an avatar that takes the synthesized speech and converts it into realistic animations, creating a speaking digital assistant that delivers your financial insights.

This application represents part of an interactive AI holograms exhibit showcased at Oracle conferences, demonstrating the future of human-computer interaction in financial services. The system illustrates how Oracle's converged database platform seamlessly integrates speech processing, natural language understanding, vector search, and traditional SQL capabilities to create intuitive, voice-driven financial analytics experiences.

### Prerequisites

This lab only requires that you have completed the setup lab.

## Task 1: Build and deploy the service

Run `./build_and_deploy.sh` at [this location](https://github.com/paulparkinson/oracle-ai-for-sustainable-dev/tree/main/financial/graph-circular-payments).

1. Follow the steps found on the AI Hub here: https://www.oracle.com/artificial-intelligence/speak-with-ai-about-data-using-real-time/

2. If you would like to further enhance the demo to use the Unreal MetaHuman interface, follow the steps found here: https://www.linkedin.com/pulse/interactive-ai-holograms-develop-digital-double-oracle-paul-parkinson-zdpjf

You may now proceed to the next lab.

## Learn More

* [Oracle Database](https://bit.ly/mswsdatabase)

## Acknowledgements
* **Authors** - Paul Parkinson, Architect and Developer Advocate
* **Last Updated By/Date** - Paul Parkinson, 2025
