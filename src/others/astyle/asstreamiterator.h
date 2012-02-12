/*
 * This file is part of the Code::Blocks IDE and licensed under the GNU General Public License, version 3
 * http://www.gnu.org/licenses/gpl-3.0.html
 */

#ifndef ASSTREAMITERATOR_H
#define ASSTREAMITERATOR_H

#include <string>
#include "astyle.h"

class ASStreamIterator : public astyle::ASSourceIterator
{
    public:
        ASStreamIterator(const char *in);
        virtual ~ASStreamIterator();

        bool hasMoreLines() const;
        std::string nextLine(bool emptyLineWasDeleted = false);
        std::string peekNextLine();
        void peekReset();
        
    protected:
        bool IsEOL(char ch);
        const char *m_In;
        const char *m_PeekStart;
        std::string m_buffer;
        int m_curline;

    private:
        std::string readLine();
};

#endif // ASSTREAMITERATOR_H
